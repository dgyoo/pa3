% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
% This class encodes Fisher vector.
classdef Fisher < handle
    properties
        regnDscrbr; % Region describer providing multi-scale dense local activations.
        setting;    % Parameters.
    end
    methods
        function this = Fisher...
                ( regnDscrbr, setting )
            this.regnDscrbr = regnDscrbr;
            this.setting.spatialPyramid = '11'; % Spatial pyramid layout. '1131' denotes '1 by 1' and '3 by 1'.
            this.setting = setChanges...
                ( this.setting, setting, upper( mfilename ) );
        end
        function fisher = iid2desc( this, iid )
            % Extract multi-scale dense local activations.
            [ rid2geo, rid2desc, imsize ] = ...
                this.regnDscrbr.iid2regdesc( iid, false );
            % Spatial-pyramid Fisher.
            spatialPyramid = this.setting.spatialPyramid;
            gmm = this.regnDscrbr.gmm;
            fisher = encodeFisher( rid2geo, rid2desc, imsize, gmm, spatialPyramid );
        end
        function fisher = im2desc( this, im )
            % Extract multi-scale dense local activations.
            [ rid2geo, rid2desc, imsize ] = ...
                this.regnDscrbr.im2regdesc( im );
            % Spatial-pyramid Fisher.
            spatialPyramid = this.setting.spatialPyramid;
            gmm = this.regnDscrbr.gmm;
            fisher = encodeFisher( rid2geo, rid2desc, imsize, gmm, spatialPyramid );
        end
        % Functions for object identification.
        function name = getName( this )
            name = sprintf( 'FV_%s_OF_%s', ...
                this.setting.changes, ...
                this.regnDscrbr.getName );
            name( strfind( name, '__' ) ) = '';
            if name( end ) == '_', name( end ) = ''; end;
        end
    end
end