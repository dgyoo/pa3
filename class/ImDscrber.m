% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
% This class describe an image by source image describers.
classdef ImDscrber < handle
    properties
        db;         % Dataset to be described.
        srcDscrber; % Source image-describers. Can be any kind of image describers such as Fisher, Single, AP.
        setting;    % Parameters.
    end
    methods
        function this = ImDscrber...
                ( db, srcDscrber, setting )
            this.db = db;
            this.srcDscrber = srcDscrber;
            this.setting.weights = ones( size( srcDscrber ) ); % Combining weights between multiple image-describers.
            this.setting = setChanges...
                ( this.setting, setting, upper( mfilename ) );
        end
        function descDb( this )
            numDscrber = numel( this.srcDscrber );
            did2iid2exist = cell( numDscrber, 1 );
            for did = 1 : numDscrber
                fprintf( '%s: Check if descs exist.\n', ...
                    upper( mfilename ) );
                iid2vpath = cellfun( ...
                    @( iid )this.getPath( iid, did ), ...
                    num2cell( 1 : this.db.getNumIm )', ...
                    'UniformOutput', false );
                did2iid2exist{ did } = cellfun( ...
                    @( path )exist( path, 'file' ), ...
                    iid2vpath );
                this.makeDir( did );
            end;
            did2iid2exist = cat( 2, did2iid2exist{ : } );
            iid2exist = prod( did2iid2exist, 2 );
            iids = find( ~iid2exist );
            if isempty( iids ),
                fprintf( '%s: No im to desc.\n', ...
                    upper( mfilename ) ); return;
            end;
            cnt = 0; cummt = 0; numIm = numel( iids );
            for iid = iids'; itime = tic;
                this.iid2desc( iid, 'NONE', 'NONE' );
                cummt = cummt + toc( itime );
                cnt = cnt + 1;
                fprintf( '%s: ', upper( mfilename ) );
                disploop( numIm, cnt, ...
                    'Desc im.', cummt );
            end;
        end
        function desc = iid2desc...
                ( this, iid, kernel, norm )
            weights = this.setting.weights;
            numDscrber = numel( this.srcDscrber );
            did2desc = cell( numDscrber, 1 );
            for did = 1 : numDscrber
                fpath = this.getPath( iid, did );
                try
                    data = load( fpath );
                    desc = data.desc;
                catch
                    desc = this.srcDscrber{ did }.iid2desc( iid );
                    save( fpath, 'desc' );
                end;
                desc = kernelMap( desc, kernel );
                desc = nmlzVecs( desc, norm );
                did2desc{ did } = desc * weights( did );
            end
            if nargout, desc = cat( 1, did2desc{ : } ); end;
        end
        function desc = im2desc...
                ( this, im, kernel, norm )
            weights = this.setting.weights;
            numDscrber = numel( this.srcDscrber );
            did2desc = cell( numDscrber, 1 );
            for did = 1 : numDscrber
                desc = this.srcDscrber{ did }.im2desc( im );
                desc = kernelMap( desc, kernel );
                desc = nmlzVecs( desc, norm );
                did2desc{ did } = desc * weights( did );
            end
            desc = cat( 1, did2desc{ : } );
        end
        % Functions for data I/O.
        function name = getName( this, dscrberId )
            if nargin > 1
                if ~isempty( this.setting.changes )
                    changes = strsplit( this.setting.changes, '_' );
                    foo = cellfun( @( str )strcmp( str( 1 : 2 ), 'W[' ), changes );
                    if any( foo ),
                        len = numel( changes{ foo } );
                        idx = strfind( this.setting.changes, changes{ foo } );
                        changes = this.setting.changes;
                        changes( idx : idx + len - 1 ) = [];
                    else
                        changes = this.setting.changes;
                    end
                else
                    changes = this.setting.changes;
                end
                name = sprintf( 'ID_%s_OF_%s', ...
                    changes, ...
                    this.srcDscrber{ dscrberId }.getName );
            else
                numDscrber = numel( this.srcDscrber );
                name = { };
                name{ end + 1 } = ...
                    sprintf( 'ID_%s_OF_', this.setting.changes );
                for did = 1 : numDscrber
                    if did > 1, name{ end + 1 } = '_AND_'; end;
                    name{ end + 1 } = ...
                        this.srcDscrber{ did }.getName;
                end
                name = cat( 2, name{ : } );
            end
            name( strfind( name, '__' ) ) = '';
            if name( end ) == '_', name( end ) = ''; end;
        end
        function dir = getDir( this, dscrberId )
            name = this.getName( dscrberId );
            if length( name ) > 150,
                name = sum( ( name - 0 ) .* ( 1 : numel( name ) ) );
                name = sprintf( '%010d', name );
                name = strcat( 'ID_', name );
            end
            dir = fullfile...
                ( this.db.dstDir, name );
        end
        function dir = makeDir( this, dscrberId )
            dir = this.getDir( dscrberId );
            if ~exist( dir, 'dir' ), mkdir( dir ); end;
        end
        function fpath = getPath( this, iid, dscrberId )
            fname = sprintf...
                ( 'ID%06d.mat', iid );
            fpath = fullfile...
                ( this.getDir( dscrberId ), fname );
        end
    end
end