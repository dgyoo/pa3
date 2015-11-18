% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
% This function evaluates test vectors by the trained multi-class SVM.
% INOUT.
%   cid2w:          [ (N + 1) x numClass, matrix ] i-th column is (N+1)-dimensional SVM weights (a bias is also included) of i-th class.
%   idx2desc:       [ N x numVector, matrix ] N-dimensional test vectors to be evaluated.
% OUTPUT.
%   idx2cid2score:	[ numClass x numVector, matrix ] Entry at i-th row and j-th column is the j-th image score of i-th class SVM.
% GIVEN FUNCTION.
%   None.
function idx2cid2score = testSvm( cid2w, idx2desc )
end