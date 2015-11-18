% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
% This function samples large amount of region activations to be used for training GMM/PCA.
% INOUT.
%   db:                     A DB to provide training images.
%   net:                    A pre-trained network to extract local activations.
%   patchSide:              Side length of an image region corrensponding to a single activation vector in an activation map, when we feed a large image into a CNN.
%   stride:                 Image-region stride when we feed a large image into a CNN.
%   lyid:                   Target layer ID where activations are extracted.
%   numScale:               Number of scales for extracting multi-scale dense activations.
%                           The shorter side of the minimum scale image should be the patchSide.
%                           If an image area is A at a scale, the image area of the next scale should be 2A.
%   numGaussian:            Number of Gaussians.
%   maxNumSrcIm:            Maxmum number of source image to collect region activations for training GMM/PCA.
%   numSamplePerGaussian:   Rough number of region activations which belong to a single Gaussian.
% OUTPUT.
% 	descs:                  [ N x numSample, matrix ] N-dimensional local activations.
% GIVEN FUNCTION.
%   vl_simplenn(). (You can also use extMultiScaleDenseActivation())
% HINT.
%   Determine the number of regions to be sampled per image by using numGaussian, maxNumSrcIm, numSamplePerGaussian.
%   Utilize extMultiScaleDenseActivation(), which you should fill.
function descs = sampleRegnDesc( db, net, patchSide, stride, lyid, numScale, numGaussian, maxNumSrcIm, numSamplePerGaussian )
end