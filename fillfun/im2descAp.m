% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
% This function describe an image by global activations from a pre-trained CNN.
% INOUT.
%   im:                 A target image.
%   net:                A pre-trained network.
%   augmentationType:   'SINGLE' for "single activation" and 'AP' for "average pooling".
%   averageImage:       average image for input image normalization.
%   keepAspect:         An option to keep the aspect ratio when we resize the image before crop.
%   interpolation:      Interpolation method when we resize images.
%   layerId:            Target layer ID where activations are extracted.
% OUTPUT.
%   desc:               [ N x 1, matrix ] An N-dimensional global image descriptor.
% GIVEN FUNCTION.
%   vl_simplenn().
% HINT.
%   Single activation: Feed a center crop of an input image to the network.
%   Average pooling: Feed 25 random crops and their flips of an input image to the network, and average the 50 activation vectors.
function desc = im2descAp( im, net, augmentationType, averageImage, keepAspect, interpolation, layerId )
end