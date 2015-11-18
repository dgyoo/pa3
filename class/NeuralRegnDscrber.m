% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
% This class describe multi-scale dense regions by CNN.
% This class also train a PCA for dimensionality reduction of high dimensional local activations.
% This class also train a GMM dictionary with the dimensionality-reduced local activations.
classdef NeuralRegnDscrber < handle
    properties
        db;             % Dataset to be described.
        net;            % Pre-trained network for feed-forwarding.
        gmm;            % GMM dictionary data.
        pca;            % PCA data for dimensionality reduction.
        patchSide;      % Side length of an image patch corrensponding to a single activation vector in an activation map, when we feed a large image into a CNN.
        stride;         % Image-patch stride when we feed a large image into a CNN.
        settingDesc;    % Parameters for patch description.
        settingDic;     % Parameters for GMM dictionary.
    end
    methods
        function this = NeuralRegnDscrber...
                ( db, net, settingDesc, settingDic )
            this.db                             = db;
            this.net                            = net;
            this.settingDesc.layerId            = numel( net.layers ) - 2;  % Target layer ID. This code is FC7 in Alex-based nets.
            this.settingDesc.numScale           = 7;                        % Number of scales for extracting multi-scale dense activations.
            this.settingDesc.pcaDim             = 128;                      % Target dimention of an activation after dimensionality reduction by PCA.
            this.settingDesc.normBeforePca      = 'L2';                     % Normalization type before PCA.
            this.settingDesc.normAfterPca       = 'L2';                     % Normalization type after PCA.
            this.settingDic.numGaussian         = 256;                      % Number of Gaussians for GMM dictionary.
            this.settingDesc = setChanges...
                ( this.settingDesc, settingDesc, upper( mfilename ) );
            this.settingDic = setChanges...
                ( this.settingDic, settingDic, upper( mfilename ) );
        end
        function init( this, gpu )
            if gpu,
                this.net = vl_simplenn_move...
                    ( this.net, 'gpu' );
            end;
            idx = strfind( this.net.layers{end}.type, 'loss' );
            if ~isempty( idx ),
                this.net.layers{ end }.type( idx : end ) = [  ];
            end;
            [ this.patchSide, this.stride ] = ...
                getNetProperties( this.net, this.settingDesc.layerId );
        end
        function trainDic( this )
            fpath = this.getDicPath;
            try
                data = load( fpath );
                this.gmm = data.gmm;
                this.pca = data.pca;
                fprintf( '%s: Dic loaded.\n', ...
                    upper( mfilename ) );
            catch
                normBeforePca = this.settingDesc.normBeforePca;
                pcaDim = this.settingDesc.pcaDim;
                normAfterPca = this.settingDesc.normAfterPca;
                numGaussian = this.settingDic.numGaussian;
                this.pca = [  ];
                this.gmm = [  ];
                if isfinite( pcaDim ) || numGaussian,
                    % Get descriptors.
                    descs = this.sampleDescs;
                    descs = nmlzVecs...
                        ( descs, normBeforePca );
                    % Learn PCA and reduce dim.
                    if isfinite( pcaDim ),
                        fprintf( '%s: Train PCA.\n', upper( mfilename ) );
                        [ this.pca.proj, this.pca.center ] = learnPca( pcaDim, descs );
                        descs = reduceDimByPca( descs, this.pca );
                    end;
                    descs = nmlzVecs( descs, normAfterPca );
                    % Learn GMM.
                    if numGaussian,
                        fprintf( '%s: Train GMM.\n', upper( mfilename ) );
                        v = var( descs, [  ], 2 );
                        initialization = 'KMEANS';
                        numRepetitions = 1;
                        covarianceBound = double( max( v ) * 0.0001 );
                        [ this.gmm.means, this.gmm.covs, this.gmm.priors ] = ...
                            leanDicByGmm( descs, numGaussian, initialization, numRepetitions, covarianceBound );
                    end;
                end;
                fprintf( '%s: Save dic.\n', upper( mfilename ) );
                gmm = this.gmm;
                pca = this.pca;
                save( fpath, 'gmm', 'pca' );
                fprintf( '%s: Done.\n', upper( mfilename ) );
            end
        end
        function descDb( this )
            % Check if descs exist.
            fprintf( '%s: Check if descs exist.\n', ...
                upper( mfilename ) );
            iid2vpath = cellfun( ...
                @( iid )this.getDescPath( iid ), ...
                num2cell( 1 : this.db.getNumIm )', ...
                'UniformOutput', false );
            iid2exist = cellfun( ...
                @( path )exist( path, 'file' ), ...
                iid2vpath );
            this.makeDescDir;
            iids = find( ~iid2exist );
            if isempty( iids ),
                fprintf( '%s: No im to desc.\n', ...
                    upper( mfilename ) ); return;
            end
            % Do the job.
            cnt = 0; cummt = 0; numIm = numel( iids );
            for iid = iids'; itime = tic;
                this.iid2regdesc( iid, true );
                cummt = cummt + toc( itime );
                cnt = cnt + 1;
                fprintf( '%s: ', upper( mfilename ) );
                disploop( numIm, cnt, ...
                    'Desc im regns.', cummt );
            end
        end
        function [ rid2geo, rid2desc, imsize ] = ...
                iid2regdesc( this, iid, saveData )
            normBeforePca = this.settingDesc.normBeforePca;
            normAfterPca = this.settingDesc.normAfterPca;
            fpath = this.getDescPath( iid );
            try
                data = load( fpath );
                rid2desc = data.rid2desc;
                rid2geo = data.rid2geo;
                imsize = data.imsize;
            catch
                [ rid2geo, rid2desc, imsize ] = ...
                    this.iid2rawregdesc( iid );
                rid2desc = nmlzVecs...
                    ( rid2desc, normBeforePca );
                if ~isempty( this.pca )
                    rid2desc = reduceDimByPca( rid2desc, this.pca );
                end;
                if saveData,
                    save( fpath, 'rid2geo', 'rid2desc', 'imsize' ); end;
            end
            rid2desc = nmlzVecs...
                ( rid2desc, normAfterPca );
        end
        function [ rid2geo, rid2desc, imsize ] = ...
                im2regdesc( this, im )
            normBeforePca = this.settingDesc.normBeforePca;
            normAfterPca = this.settingDesc.normAfterPca;
            [ rid2geo, rid2desc, imsize ] = ...
                this.im2rawregdesc( im );
            rid2desc = nmlzVecs...
                ( rid2desc, normBeforePca );
            if ~isempty( this.pca )
                rid2desc = reduceDimByPca( rid2desc, this.pca );
            end
            rid2desc = nmlzVecs( rid2desc, normAfterPca );
        end
        function [ rid2geo, rid2desc, imsize ] = ...
                iid2rawregdesc( this, iid )
            im = imread...
                ( this.db.iid2impath{ iid } );
            [ rid2geo, rid2desc, imsize ] = ...
                this.im2rawregdesc( im );
        end
        function [ rid2tlbr, rid2desc, imSize ] = ...
                im2rawregdesc( this, im )
            lyid = this.settingDesc.layerId;
            numScale = this.settingDesc.numScale;
            itpltn = this.net.normalization.interpolation;
            [ rid2tlbr, rid2desc, imSize ] = ...
                extMultiScaleDenseActivation...
                ( im, this.net, this.patchSide, this.stride, lyid, numScale, itpltn );
        end
        function descs = sampleDescs( this )
            fpath = this.getSmplDescPath;
            try
                fprintf( '%s: Try to load training regn descs.\n', upper( mfilename ) );
                data = load( fpath );
                descs = data.descs;
                fprintf( '%s: Loaded.\n', upper( mfilename ) );
            catch
                this.makeSmplDescDir;
                lyid = this.settingDesc.layerId;
                numScale = this.settingDesc.numScale;
                numGaussian = this.settingDic.numGaussian;
                maxNumSrcIm = 1000;
                numSamplePerGaussian = 1000;
                descs = sampleRegnDesc...
                    ( this.db, this.net, this.patchSide, this.stride, lyid, numScale, numGaussian, maxNumSrcIm, numSamplePerGaussian );
                fprintf( '%s: Save regn descs.\n', upper( mfilename ) );
                save( fpath, 'descs', '-v7.3' );
                fprintf( '%s: Done.\n', ...
                    upper( mfilename ) );
            end
        end
        % Functions for sample descriptor I/O.
        function name = getSmplDescName( this )
            numScale = this.settingDesc.numScale;
            name = sprintf( 'NRDMSMPL_LI%d_NS%d_OF_%s', ...
                this.settingDesc.layerId, ...
                numScale, ...
                this.net.name );
            name( strfind( name, '__' ) ) = '';
        end
        function dir = getSmplDescDir( this )
            dir = this.db.dstDir;
        end
        function dir = makeSmplDescDir( this )
            dir = this.getSmplDescDir;
            if ~exist( dir, 'dir' ), mkdir( dir ); end;
        end
        function fpath = getSmplDescPath( this )
            name = this.getSmplDescName;
            fname = strcat( name, '.mat' );
            fpath = fullfile...
                ( this.getSmplDescDir, fname );
        end
        % Functions for dictionary I/O.
        function name = getName( this )
            name = sprintf( 'DIC_%s_OF_%s', ...
                this.settingDic.changes, ...
                this.getDescName );
            name( strfind( name, '__' ) ) = '';
            if name( end ) == '_', name( end ) = ''; end;
        end
        function dir = getDicDir( this )
            dir = this.db.dstDir;
        end
        function dir = makeDicDir( this )
            dir = this.getDicDir;
            if ~exist( dir, 'dir' ), mkdir( dir ); end;
        end
        function fpath = getDicPath( this )
            name = this.getName;
            if length( name ) > 150, 
                name = sum( ( name - 0 ) .* ( 1 : numel( name ) ) ); 
                name = sprintf( '%010d', name ); 
                name = strcat( 'DIC_', name );
            end
            fname = strcat( name, '.mat' );
            fpath = fullfile...
                ( this.getDicDir, fname );
        end
        % Functions for descriptor I/O.
        function name = getDescName( this )
            name = sprintf( 'NRDM_%s_OF_%s', ...
                this.settingDesc.changes, ...
                this.net.name );
            name( strfind( name, '__' ) ) = '';
            if name( end ) == '_', name( end ) = ''; end;
        end
        function dir = getDescDir( this )
            name = this.getDescName;
            if length( name ) > 150, 
                name = sum( ( name - 0 ) .* ( 1 : numel( name ) ) ); 
                name = sprintf( '%010d', name );
                name = strcat( 'NRDM_', name );
            end
            dir = fullfile...
                ( this.db.dstDir, name );
        end
        function dir = makeDescDir( this )
            dir = this.getDescDir;
            if ~exist( dir, 'dir' ), mkdir( dir ); end;
        end
        function fpath = getDescPath( this, iid )
            fname = sprintf...
                ( 'ID%06d.mat', iid );
            fpath = fullfile...
                ( this.getDescDir, fname );
        end
    end
end