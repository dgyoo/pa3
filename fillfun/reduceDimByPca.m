% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
% This function reduces the dimensionality of vectors by PCA.
% INOUT.
%   descs:  [ N x M, matrix ] M N-dimensional descriptors.
%   pca:    PCA projection matrix. It contains { projection matrix, center } as fields. (e.g. pca.proj, pca.center.)
% OUTPUT.
%   descs:  [ k x M, matrix ] M k-dimensional descriptors where k is smaller than N.
% GIVEN FUNCTION.
%   None.
function descs = reduceDimByPca( descs, pca )
end