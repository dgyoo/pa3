% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
% This function computes the patch side and the stride of a pre-trained CNN.
% INOUT.
%   net:            A pre-trained network.
%   targetLyrId:    Target layer ID where activations are extracted.
% OUTPUT.
%   patchSide:      Side length of an image region corrensponding to a single activation vector in an activation map, when we feed a large image into a CNN.
%   stride:         Image-region stride when we feed a large image into a CNN.
% GIVEN FUNCTION.
%   Use vl_simplenn() if you determine patch side and stride by an empirical way (See the following).
% HINT.
%   Patch side and stride can be computed by a theoritical way or an empirical way.
%   Theoritical way: Carefully trace all operations in each layer and mathematically determine the patch side and stride.
%   Empirical way: Utilize "try-catch" statement in MATLAB to feed varying size of input images and observe the changes of output size.
function [ patchSide, stride ] = getNetProperties( net, targetLyrId )
end

