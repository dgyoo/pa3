% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
% This function trains a binary SVM.
% INOUT.
%   idx2desc:           [ N x numVector, matrix ] i-th column is the i-th N-dimensional training descriptor.
%   idx2iid:            [ numVector x 1, matrix ] i-th row has the image ID of i-th training descriptor.
%   cid:                Target class ID.
%   db:                 DB prociding various image informations.
%   epsilon:            SVM parameter.
%   biasMultiplier:     SVM parameter.
%   biasLearningRate:   SVM parameter.
%   loss:               SVM parameter.
%   solver:             SVM parameter.
%   lambda:             SVM parameter.
% OUTPUT.
%   w:                  [ N x 1, matrix ] Weight of SVM.
%   b:                  Bias of SVM.
% GIVEN FUNCTION.
%   vl_svmtrain().
function [ w, b ] = trainBinarySvm( idx2desc, idx2iid, cid, db, epsilon, biasMultiplier, biasLearningRate, loss, solver, lambda )
end