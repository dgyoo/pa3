% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
% This function trains the projection matrix for PCA dimensionality reduction.
% INOUT.
%   dim:    Target dimensionality after reduction.
%   vecs:   [ N x numVector, matrix ] N-dimensional training vectors to train the projection matrix.
% OUTPUT.
%   proj:   [ dim x N, matrix ] Projection matrix.
%   center: [ N x 1, matrix ] A mean vector of the training vectors.
% GIVEN FUNCTION.
%   NONE!!! DO NOT USE MATLAB BUILT IN FUNCTIONS FOR PCA!!!
function [ proj, center ] = learnPca( dim, vecs )
end