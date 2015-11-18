% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
% This function computes a spatial pyramid Fisher vector from multi-scale dense activations.
% INOUT.
%   rid2tlbr:       [ 4 x numRegion, matrix ] Region ID to coordinates at top-left and bottom-right. 
%                   i-th column has the top-left and bottom-right coordinates of i-th region in the order of [ rowTopLeft; columnTopLeft; rowBottomRight; columnBottomRight ].
%   rid2desc:       [ N x numRegion, matrix ] Region ID to descriptor.
%                   i-th column is a N-dimensional descriptor of i-th region.
%   imsize:         Image size where the regions are extracted.
%   gmm:            GMM as a visual dictionary. It contains k-{ means, covariances, and priors } as fields. (e.g. gmm.mean, gmm.covs, gmm.priors)
%   spatialPyramid: A string representing the spatial pyramid layout. For example, '1131' denotes '1 by 1' and '3 by 1'.
% OUTPUT.
% 	fisher:         [ M x 1, matrix ] A M-dimensional Fisher vector.
% GIVEN FUNCTION.
%   vl_fisher().
function fisher = encodeFisher( rid2tlbr, rid2desc, imsize, gmm, spatialPyramid )
end