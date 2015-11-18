% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
% This function extracts multi-scale dense activations.
% INOUT.
%   im:             Image.
%   net:            A pre-trained network.
%   patchSide:      Side length of an image region corrensponding to a single activation vector in an activation map, when we feed a large image into a CNN.
%   stride:         Image-region stride when we feed a large image into a CNN.
%   lyid:           Target layer ID where activations are extracted.
%   numScale:       Number of scales for extracting multi-scale dense activations.
%                   The shorter side of the minimum scale image should be the patchSide.
%                   If an image area is A at a scale, the image area of the next scale should be 2A.
%   interpolation:  Interpolation method to resize image.
% OUTPUT.
%   rid2tlbr:       [ 4 x numRegion, matrix ] Region ID to coordinates at top-left and bottom-right. 
%                   i-th column has the top-left and bottom-right coordinates of i-th region in the order of [ rowTopLeft; columnTopLeft; rowBottomRight; columnBottomRight ].
%   rid2desc:       [ N x numRegion, matrix ] Region ID to descriptor.
%                   i-th column is a N-dimensional descriptor (=activation) of i-th region.
%   imSize:         Image size where the regions are extracted.
% GIVEN FUNCTION.
%   vl_simplenn().
function [ rid2tlbr, rid2desc, imSize ] = extMultiScaleDenseActivation( im, net, patchSide, stride, lyid, numScale, interpolation )
end

