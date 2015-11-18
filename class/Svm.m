% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
% This class train/test SVMs.
classdef Svm < handle
    properties
        db;                 % Dataset to be used for training.
        srcImDscrber;       % Source image-describer to describe images for training SVMs.
        result;             % Evaluation results.
        setting;
    end    
    methods
        function this = Svm( db, srcImDscrber, setting )
            this.db                         = db;
            this.srcImDscrber               = srcImDscrber;
            this.setting.kernel             = 'NONE';       % Additive kernel map before training SVMs.
            this.setting.norm               = 'L2';         % Normalization type before training SVMs.
            this.setting.c                  = 10;           % SVM parameter.
            this.setting.epsilon            = 1e-3;         % SVM parameter.
            this.setting.biasMultiplier     = 1;            % SVM parameter.
            this.setting.biasLearningRate   = 0.5;          % SVM parameter.
            this.setting.loss               = 'HINGE';      % SVM parameter.
            this.setting.solver             = 'SDCA';       % SVM parameter.
            this.setting = setChanges...
                ( this.setting, setting, upper( mfilename ) );
        end
        function trainSvm( this )
            fprintf( '%s: Check if svm exist.\n', ...
                upper( mfilename ) );
            cid2path = cellfun( ...
                @( cid )this.getSvmPath( cid ), ...
                num2cell( 1 : this.db.getNumClass )', ...
                'UniformOutput', false );
            cid2exist = cellfun( ...
                @( path )exist( path, 'file' ), ...
                cid2path );
            cids = find( ~cid2exist );
            if isempty( cids ), 
                fprintf( '%s: No svm to train.\n', ...
                    upper( mfilename ) ); return; 
            end;
            idx2iid = this.db.getTriids;
            idx2iid = idx2iid( randperm( numel( idx2iid ) )' );
            idx2desc = this.loadDbDescs( idx2iid );
            this.makeDir;
            cnt = 0; cummt = 0; numIm = numel( cids );
            for cid = cids'; itime = tic;
                this.cid2svm( cid, idx2desc, idx2iid );
                cummt = cummt + toc( itime ); 
                cnt = cnt + 1;
                fprintf( '%s: ', upper( mfilename ) );
                disploop( numIm, cnt, ...
                    sprintf( 'train svm of class %d.', cid ), cummt );
            end
        end
        function evalSvm( this, addrss )
            [ cid2teidx2score, cid2teidxs, cid2didxs ] ...
                = this.testSvm;
            mssg = this.writeReport( cid2teidxs, cid2didxs, cid2teidx2score );
            cellfun( @( str )fprintf( '%s\n', str ), mssg );
            title = sprintf( '%s: TEST REPORT', ...
                upper( mfilename ) );
            if ~isempty( addrss )
                sendEmail( ...
                    'visionresearchreport@gmail.com', ...
                    'visionresearchreporter', ...
                    addrss, title, mssg, [  ] );
            end
        end
        function cid2score = predictIm( this, im )
            kernel = this.setting.kernel;
            norm = this.setting.norm;
            cid2w = this.loadSvm;
            desc = this.srcImDscrber.im2desc...
                ( im, kernel, norm );
            desc = cat( 1, desc, 1 );
            cid2score = cid2w' * desc;
        end
        function descs = loadDbDescs( this, iids )
            kernel = this.setting.kernel;
            norm = this.setting.norm;
            numIm = numel( iids );
            descs = cell( numIm, 1 );
            prgrss = 0; cummt = 0; numIm = numel( iids );
            for i = 1 : numIm; itime = tic; iid = iids( i );
                desc = this.srcImDscrber.iid2desc...
                    ( iid, kernel, norm );
                descs{ i } = desc;
                cummt = cummt + toc( itime ); prgrss = prgrss + 1;
                if ( prgrss / numIm ) >= 0.1; prgrss = 0;
                    fprintf( '%s: ', upper( mfilename ) );
                    disploop( numIm, i, 'Load descs.', cummt );
                end
            end
            descs = cat( 2, descs{ : } );
        end
        function w = cid2svm( this, cid, idx2desc, idx2iid )
            fpath = this.getSvmPath( cid );
            try
                data = load( fpath );
                w = data.w;
            catch
                c = this.setting.c;
                epsilon = this.setting.epsilon;
                biasMultiplier = this.setting.biasMultiplier;
                biasLearningRate = this.setting.biasLearningRate;
                loss = this.setting.loss;
                solver = this.setting.solver;
                numDesc = size( idx2desc, 2 );
                lambda = 1 / ( numDesc * c );
                [ w, b ] = trainBinarySvm( idx2desc, idx2iid, cid, this.db, ...
                    epsilon, biasMultiplier, biasLearningRate, loss, solver, lambda );
                w = cat( 1, w, b );
                save( fpath, 'w' );
            end
        end
        function [ idx2cscore, cid2idxs, cid2didxs ] = ...
                testSvm( this )
            path = this.getTestPath;
            idx2iid = this.db.getTeiids;
            cid2idxs = this.db.getCid2idxs( idx2iid );
            cid2didxs = this.db.getCid2didxs( idx2iid );
            try
                data = load( path );
                idx2cscore = data.idx2cscore;
            catch
                idx2desc = this.loadDbDescs( idx2iid );
                cid2w = this.loadSvm;
                idx2cscore = testSvm( cid2w, idx2desc );
                this.makeDir;
                save( path, 'idx2cscore' );
            end
        end
        function cid2w = loadSvm( this )
            fprintf( '%s: load svm.\n', upper( mfilename ) );
            cids = num2cell( 1 : this.db.getNumClass );
            cid2w = cellfun...
                ( @( cid )this.cid2svm( cid, [  ], [  ] ), ...
                cids, 'UniformOutput', false );
            cid2w = cat( 2, cid2w{ : } );
        end
        % Functions to report the result.
        function mssg = writeReport...
                ( this, cid2teidxs, cid2didxs, cid2teidx2score )
            mssg = {  };
            mssg{ end + 1 } = '___________';
            mssg{ end + 1 } = 'TEST REPORT';
            mssg{ end + 1 } = sprintf( 'DATABASE: %s', this.db.name );
            mssg{ end + 1 } = sprintf( 'IMAGE DESCRIBER: %s', this.srcImDscrber.getName );
            mssg{ end + 1 } = sprintf( 'CLASSIFIER: %s', this.getName );
            [ this.result.cid2ap, this.result.cid2ap11 ] = this.computeAp...
                ( cid2teidx2score, cid2teidxs, cid2didxs );
            mssg{ end + 1 } = sprintf( 'MAP: %.2f%%', ...
                mean( this.result.cid2ap ) * 100 );
            mssg{ end + 1 } = sprintf( 'MAP11: %.2f%%', ...
                mean( this.result.cid2ap11 ) * 100 );
            if ~this.db.isMutiLabel,
                idx2cid = cell2mat( this.db.iid2cids( this.db.getTeiids ) );
                this.result.top1 = this.computeTopAcc( idx2cid, cid2teidx2score, 1 ) * 100;
                [ this.result.acc, this.result.cid2acc, this.result.confMat ] = ...
                    this.computeAcc( idx2cid, cid2teidx2score );
                mssg{ end + 1 } = sprintf( 'TOP1 ACCURACY: %.2f%%', this.result.top1 );
                mssg{ end + 1 } = sprintf( 'ACCURACY: %.2f%%', this.result.acc );
            end;
        end
        % Functions for data I/O.
        function name = getName( this )
            name = sprintf( 'SB_%s_OF_%s', ...
                this.setting.changes, ...
                this.srcImDscrber.getName );
            name( strfind( name, '__' ) ) = '';
            if name( end ) == '_', name( end ) = ''; end;
        end
        function dir = getDir( this )
            name = this.getName;
            if length( name ) > 150, 
                name = sum( ( name - 0 ) .* ( 1 : numel( name ) ) ); 
                name = sprintf( '%010d', name ); 
                name = strcat( 'SB_', name );
            end
            dir = fullfile...
                ( this.db.dstDir, name );
        end
        function dir = makeDir( this )
            dir = this.getDir;
            if ~exist( dir, 'dir' ), mkdir( dir ); end;
        end
        function fpath = getSvmPath( this, cid )
            fname = sprintf...
                ( 'ID%04d.mat', cid );
            fpath = fullfile...
                ( this.getDir, fname );
        end
        function fpath = getTestPath( this )
            fname = 'TE.mat';
            fpath = fullfile...
                ( this.getDir, fname );
        end
    end
    methods( Static )
        function metric = computeTopAcc( idx2cid, idx2cscore, topn )
            idx2cid = idx2cid( : );
            [ ~, idx2topcid ] = sort( idx2cscore, 1, 'descend' );
            idx2topncid = idx2topcid( 1 : topn, : );
            idx2hit = ~prod( idx2topncid - repmat( idx2cid', topn, 1 ), 1 );
            metric = mean( idx2hit );
        end
        function [ cid2ap, cid2ap11 ] = computeAp...
                ( idx2cscore, cid2idxs, cid2didxs )
            numClass = numel( cid2idxs );
            numDesc = size( idx2cscore, 2 );
            cid2ap = zeros( numClass, 1 );
            cid2ap11 = zeros( numClass, 1 );
            for cid = 1 : numClass,
                idx2y = -1 * ones( numDesc, 1 );
                idx2y( cid2idxs{ cid } ) = 1;
                idx2y( cid2didxs{ cid } ) = 0;
                [ ~, ~, info ] = vl_pr( idx2y, idx2cscore( cid, : )' );
                cid2ap( cid ) = info.ap;
                cid2ap11( cid ) = info.ap_interp_11;
            end;
        end
        function [ acc, cid2acc, confMat ] = computeAcc( idx2cid, idx2cscore )
            numClass = max( idx2cid );
            idx2cid = idx2cid( : );
            [ ~, idx2topcid ] = sort( idx2cscore, 1, 'descend' );
            idx2topcid = idx2topcid( 1, : );
            confMat = zeros( numClass, numClass );
            for cid = 1 : numClass,
                pcs = idx2topcid( idx2cid == cid );
                for i = 1 : numel( pcs ),
                    confMat( cid, pcs( i ) ) = confMat( cid, pcs( i ) ) + 1;
                end;
                confMat( cid, : ) = confMat( cid, : ) / numel( pcs );
            end;
            confMat = confMat * 100;
            cid2acc = diag( confMat );
            acc = mean( cid2acc );
        end
    end
end

