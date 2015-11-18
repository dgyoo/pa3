% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
% This class describe a global image by CNN.
classdef NeuralDscrbr < handle
    properties
        db;         % Dataset to be described.
        net;        % Pre-trained network for feed-forwarding.
        setting;    % Parameters.
    end
    methods
        function this = NeuralDscrbr( db, net, setting )
            this.db = db;
            this.net = net;
            this.setting.layerId = numel( net.layers ) - 2;     % Target layer ID. This code is FC7 in Alex-based nets.
            this.setting.augmentationType = 'SINGLE';           % Set 'SINGLE' for "single activation" and 'AP' for "average pooling".
            this.setting = setChanges...
                ( this.setting, setting, upper( mfilename ) );
        end
        function init( this, gpu )
            if gpu, this.net = vl_simplenn_move( this.net, 'gpu' ); end;
            idx = strfind( this.net.layers{end}.type, 'loss' );
            if ~isempty( idx ),
                this.net.layers{ end }.type( idx : end ) = [  ];
            end;
        end
        function desc = iid2desc( this, iid )
            im = imread( this.db.iid2impath{ iid } );
            desc = this.im2desc( im );
        end
        function desc = im2desc( this, im )
            augmentationType = this.setting.augmentationType;
            averageImage = this.net.normalization.averageImage;
            keepAspect = this.net.normalization.keepAspect;
            interpolation = this.net.normalization.interpolation;
            layerId = this.setting.layerId;
            desc = im2descAp( ...
                im, ...
                this.net, ...
                augmentationType, ...
                averageImage, ...
                keepAspect, ...
                interpolation, ...
                layerId );
            desc = desc( : );
        end
        % Functions for object identification.
        function name = getName( this )
            name = sprintf( 'ND_%s_OF_%s', ...
                this.setting.changes, ...
                this.net.name );
            name( strfind( name, '__' ) ) = '';
            if name( end ) == '_', name( end ) = ''; end;
        end
    end
end