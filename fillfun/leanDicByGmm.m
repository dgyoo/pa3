% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
% This function trains a GMM as a visual dictionary to be used for encoding Fisher vectors.
% INOUT.
%   vecs:               [ N x numVector, matrix ] N-dimensional training vectors to fit k Gaussians.
%   k:                  Number of Gaussians.
%   initialization:     Initialization method for fitting GMM.
%   numRepetitions:     Number of repetations for fitting GMM.
%   covarianceBound:    Covariance bound for fitting GMM.
% OUTPUT.
%   means:              [ N x k, matrix ] k N-dimensional mean vectors of k Gaussians.
%   covs:               [ N x k, matrix ] k N-dimensional covariance vectors of k Gaussians.
%   priors:             [ k x 1, matrix ] k priors (=weights) of k Gaussians.
% GIVEN FUNCTION.
%   vl_gmm().
function [ means, covs, priors ] = leanDicByGmm( vecs, k, initialization, numRepetitions, covarianceBound )
end