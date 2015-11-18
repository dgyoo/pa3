% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
% This class manages the dataset informations.
classdef Db < handle
    properties
        dstDir;     % A directory path where any processed data of this dataset is saved.
        name;       % The name of dataset.
        funh;       % A function handler to generate the following member variables.
        cid2name;   % [ numClass x 1, cell ] Class ID to class name: i-th row has the class name of i-th class.
        cid2diids;  % Ignore.
        iid2impath; % [ numImage x 1, cell ] Image ID to image path. i-th row has the image path of i-th image.
        iid2size;   % [ 2 x numImage matrix ] Image ID to image size. i-th column has the image size of i-th image in the order of [ numRow; numColumn; ].
        iid2cids;   % [ numImage x 1, cell ] Image ID to class IDs. i-th row has the class IDs of i-th image.
        iid2oids;   % Ignore.
        iid2setid;  % [ numImage x 1, matrix ] Image ID to set ID. i-th row has the set ID of i-th image. Set ID is 1 for training, or 2 for test.
        oid2cid;    % Ignore.
        oid2diff;   % Ignore.
        oid2iid;    % Ignore.
        oid2bbox;   % Ignore.
        oid2cont;   % Ignore.
    end
    methods
        function this = Db( setting, dstDir )
            this.dstDir = fullfile( dstDir, setting.name );
            this.name = setting.name;
            this.funh = setting.funh;
        end
        function genDb( this )
            fpath = this.getPath;
            try
                fprintf( '%s: Try to load db.\n', ...
                    upper( mfilename ) );
                data = load( fpath );
                db = data.db;
                fprintf( '%s: db loaded.\n', ...
                    upper( mfilename ) );
            catch
                fprintf( '%s: Gen db.\n', ...
                    upper( mfilename ) );
                [   db.cid2name, ...
                    db.iid2impath, ...
                    db.iid2size, ...
                    db.iid2setid, ...
                    db.oid2cid, ...
                    db.oid2diff, ...
                    db.oid2iid, ...
                    db.oid2bbox, ...
                    db.oid2cont ] = this.funh(  );
                if all( db.iid2setid == 3 ),
                    numIm = numel( db.iid2impath );
                    db.cid2diids = cell( 0, 1 );
                    db.iid2cids = cell( numIm, 1 );
                    db.iid2oids = cell( numIm, 1 );
                else
                    oid2out = 1 - db.oid2bbox( 1, : ) > 0;
                    db.oid2bbox( 1, oid2out ) = 1;
                    oid2out = 1 - db.oid2bbox( 2, : ) > 0;
                    db.oid2bbox( 2, oid2out ) = 1;
                    oid2out = db.iid2size( 1, db.oid2iid ) - db.oid2bbox( 3, : ) < 0;
                    db.oid2bbox( 3, oid2out ) = db.iid2size( 1, db.oid2iid( oid2out ) );
                    oid2out = db.iid2size( 2, db.oid2iid ) - db.oid2bbox( 4, : ) < 0;
                    db.oid2bbox( 4, oid2out ) = db.iid2size( 2, db.oid2iid( oid2out ) );
                    fprintf( '%s: Compute obj ids per im.\n', ...
                        upper( mfilename ) );
                    db.iid2oids = arrayfun( ...
                        @( iid )find( db.oid2iid == iid ), ...
                        ( 1 : numel( db.iid2setid ) )', ...
                        'UniformOutput', false );
                    fprintf( '%s: Done.\n', upper( mfilename ) );
                    fprintf( '%s: Compute cls ids per im.\n', ...
                        upper( mfilename ) );
                    db.iid2cids = cellfun( ...
                        @( oids )unique( db.oid2cid( oids ) ), ...
                        db.iid2oids, ...
                        'UniformOutput', false );
                    fprintf( '%s: Done.\n', upper( mfilename ) );
                    fprintf( '%s: Compute diff im ids per cls.\n', ...
                        upper( mfilename ) );
                    db.cid2diids = arrayfun( ...
                        @( cid )setdiff...
                        ( db.oid2iid( db.oid2cid == cid ), db.oid2iid( ~db.oid2diff ) ), ...
                        1 : numel( db.cid2name ), ...
                        'UniformOutput', false )';
                end;
                fprintf( '%s: Done.\n', upper( mfilename ) );
                fprintf( '%s: Save DB.\n', upper( mfilename ) );
                this.makeDir;
                save( fpath, 'db' );
                fprintf( '%s: Done.\n', upper( mfilename ) );
            end
            this.cid2name   = db.cid2name;
            this.cid2diids  = db.cid2diids;
            this.iid2impath = db.iid2impath;
            this.iid2size   = single( db.iid2size );
            this.iid2cids   = db.iid2cids;
            this.iid2oids   = db.iid2oids;
            this.iid2setid  = db.iid2setid;
            this.oid2cid    = db.oid2cid;
            this.oid2diff   = db.oid2diff;
            this.oid2iid    = db.oid2iid;
            this.oid2bbox   = single( round( db.oid2bbox ) );
            this.oid2cont   = db.oid2cont;
        end
        function numClass = getNumClass( this )
            numClass = length( this.cid2name );
        end
        function numIm = getNumIm( this )
            numIm = length( this.iid2impath );
        end
        function numIm = getNumTrIm( this )
            numIm = sum( this.iid2setid == 1 );
        end
        function numIm = getNumTeIm( this )
            numIm = sum( this.iid2setid == 2 );
        end
        function iids = getTriids( this )
            iids = find( this.iid2setid == 1 );
        end
        function iids = getTeiids( this )
            iids = find( this.iid2setid > 1 );
        end
        function ifpaths = getTrImpaths( this )
            ifpaths = this.iid2impath( this.getTriids );
        end
        function ifpaths = getTeImpaths( this )
            ifpaths = this.iid2impath( this.getTeiids );
        end
        function trImCids = getTrImCids( this )
            trImCids = this.iid2cids( this.getTriids );
        end
        function teImCids = getTeImCids( this )
            teImCids = this.iid2cids( this.getTeiids );
        end
        function ismulti = isMutiLabel( this )
            ismulti = any( cellfun( @length, this.iid2cids ) ~= 1 );
        end
        function teoids = getTrOids( this )
            teoids = find( this.iid2setid( this.oid2iid ) == 1 );
        end
        function teoids = getTeOids( this )
            teoids = find( this.iid2setid( this.oid2iid ) == 2 );
        end
        function numObj = getNumObj( this )
            numObj = numel( this.oid2iid );
        end
        function numObj = getNumTrObj( this )
            numObj = numel( this.getTrOids );
        end
        function numObj = getNumTeObj( this )
            numObj = numel( this.getTeOids );
        end
        function cid = cname2cid( this, cname )
            cid = find( strcmp( cname, this.cid2name ) );
        end;
        function cid2idxs = getCid2idxs( this, idx2iid )
            idx2cids = this.iid2cids( idx2iid );
            idx2cids = idx2cids( : );
            idxthread = cellfun( @( x, y ) y * ones( size( x ) ), ...
                idx2cids, num2cell( 1 : numel( idx2cids ) )', ...
                'UniformOutput', false );
            idxthread = cat( 1, idxthread{ : } );
            cidthread = cat( 1, idx2cids{ : } );
            numCls = this.getNumClass;
            cid2idxs = cell( numCls, 1 );
            for gtid = 1 : numCls,
                cid2idxs{ gtid } = idxthread( cidthread == gtid ); end;
        end
        function cid2didxs = getCid2didxs( this, idx2iid )
            cid2didxs = cell( this.getNumClass, 1 );
            for cid = 1 : this.getNumClass
                diids = this.cid2diids{ cid };
                didxs = arrayfun( ...
                    @( diid )find( idx2iid == diid ), ...
                    diids, ...
                    'UniformOutput', false );
                cid2didxs{ cid } = cat( 1, didxs{ : } );
            end
        end
        function newdb = mergeCls( this, newcid2cids, newDbName )
            cid2newcid = zeros( size( this.cid2name ) );
            for cid = 1 : this.getNumClass
                cid2newcid( cid ) = ...
                    find( cellfun( @( cids )ismember( cid, cids ), newcid2cids ) );
            end
            db.oid2cid = cid2newcid( this.oid2cid );
            cid2name_ = cellfun( @( name )strcat( name, ',' ), ...
                this.cid2name, 'UniformOutput', false );
            db.cid2name = cellfun( @( cids )strcat( cid2name_{ cids } ), ...
                newcid2cids, 'UniformOutput', false );
            db.cid2name = cellfun( @( name )name( 1 : end - 1 ), ...
                db.cid2name, 'UniformOutput', false );
            db.iid2impath = this.iid2impath;
            db.iid2size = this.iid2size;
            db.iid2setid = this.iid2setid;
            db.oid2diff = this.oid2diff;
            db.oid2iid = this.oid2iid;
            db.oid2bbox = this.oid2bbox;
            db.oid2cont = this.oid2cont;
            db.iid2oids = arrayfun( ...
                @( iid )find( db.oid2iid == iid ), ...
                1 : numel( db.iid2setid ), ...
                'UniformOutput', false )';
            db.iid2cids = cellfun( ...
                @( oids )unique( db.oid2cid( oids ) ), ...
                db.iid2oids, ...
                'UniformOutput', false )';
            db.cid2diids = arrayfun( ...
                @( cid )setdiff...
                ( db.oid2iid( db.oid2cid == cid ), db.oid2iid( ~db.oid2diff ) ), ...
                1 : numel( db.cid2name ), ...
                'UniformOutput', false )';
            dstDir_ = fileparts( this.dstDir );
            setting.name = upper( newDbName );
            setting.funh = this.funh;
            newdb = Db( setting, dstDir_ );
            newdb.cid2name   = db.cid2name;
            newdb.cid2diids  = db.cid2diids;
            newdb.iid2impath = db.iid2impath;
            newdb.iid2size   = db.iid2size;
            newdb.iid2cids   = db.iid2cids;
            newdb.iid2oids   = db.iid2oids;
            newdb.iid2setid  = db.iid2setid;
            newdb.oid2cid    = db.oid2cid;
            newdb.oid2diff   = db.oid2diff;
            newdb.oid2iid    = db.oid2iid;
            newdb.oid2bbox   = db.oid2bbox;
            newdb.oid2cont   = db.oid2cont;
        end
        function newdb = reduceDbByCls( this, class )
            if isnumeric( class ), 
                cid = class; 
                cname = this.cid2name{ cid };
            else
                cname = class;
                cid = cellfun( ...
                    @( name )strcmp( cname, name ), ...
                    this.cid2name );
                cid = find( cid );
            end
            iids = this.oid2iid( this.oid2cid == cid );
            iids = unique( iids );
            newdb = this.reduceDb...
                ( iids, cid, strcat( this.name, cname ) );
        end
        function newdb = reduceDb( this, iids, cids, newDbName )
            setting.dstDir = fileparts( this.dstDir );
            setting.name = upper( newDbName );
            setting.funh = this.funh;
            newdb = Db( setting );
            % Reordering.
            numim = numel( this.iid2impath );
            newiid2iid = iids;
            iid2newiid = zeros( numim, 1 );
            iid2newiid( newiid2iid ) = 1 : numel( newiid2iid );
            numclass = numel( this.cid2name );
            newcid2cid = cids;
            cid2newcid = zeros( numclass, 1 );
            cid2newcid( newcid2cid ) = 1 : numel( newcid2cid );
            numobj = numel( this.oid2iid );
            oid2ok = ismember( this.oid2iid, newiid2iid );
            oid2ok = oid2ok & ismember( this.oid2cid, newcid2cid );
            newoid2oid = find( oid2ok );
            oid2newoid = zeros( numobj, 1 );
            oid2newoid( oid2ok ) = 1 : numel( newoid2oid );
            % Reform db.
            newdb.cid2name = this.cid2name( newcid2cid );
            newdb.cid2diids = this.cid2diids( newcid2cid );
            newdb.oid2cid = cid2newcid( this.oid2cid( oid2ok ) );
            newdb.oid2iid = iid2newiid( this.oid2iid( oid2ok ) );
            newdb.oid2diff = this.oid2diff( oid2ok );
            newdb.oid2bbox = this.oid2bbox( :, oid2ok );
            newdb.oid2cont = this.oid2cont( oid2ok );
            newdb.iid2cids = this.iid2cids( newiid2iid );
            newdb.iid2cids = cellfun( ...
                @( cid )cid2newcid( cid( cid2newcid( cid ) ~= 0 ) ), ...
                newdb.iid2cids, 'UniformOutput', false );
            newdb.iid2impath = this.iid2impath( newiid2iid );
            newdb.iid2oids = this.iid2oids( newiid2iid );
            newdb.iid2oids = cellfun( ...
                @( oid )oid2newoid( oid( oid2newoid( oid ) ~= 0 ) ), ...
                newdb.iid2oids, 'UniformOutput', false );
            newdb.iid2setid = this.iid2setid( newiid2iid );
            newdb.iid2size = this.iid2size( :, newiid2iid );
            this.makeDir;
            fprintf( '%s: reduced to %s\n', ...
                upper( mfilename ), upper( newDbName ) );
        end
        function demoBbox( this, fid, position, iid )
            if nargin < 3, iid = ceil( rand * this.getNumIm ); end;
            oids = this.iid2oids{ iid };
            cids = this.oid2cid( oids );
            cnames = this.cid2name( cids );
            bboxs = this.oid2bbox( :, oids );
            im = this.iid2impath{ iid };
            figure( fid );
            plottlbr( bboxs, im, false, 'r', cnames );
            set( gcf, 'color', 'w' ); hold off;
            setFigPos( gcf, position ); drawnow;
        end;
        % Functions for object identification.
        function name = getName( this )
            name = upper( mfilename );
        end
        function dir = getDir( this )
            dir = this.dstDir;
        end
        function dir = makeDir( this )
            dir = this.getDir;
            if ~exist( dir, 'dir' ), mkdir( dir ); end;
        end
        function path = getPath( this )
            fname = strcat( this.getName, '.mat' );
            path = fullfile( this.getDir, fname );
        end
    end
end