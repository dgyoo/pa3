% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
% This function computes a confidence map of a predicted class.
% INOUT.
%   iid:       Target image ID.
%   svm:       SVM.
% OUTPUT.
%   map:       Confidence map of a predicted class.
% GIVEN FUNCTION.
%   vl_fisher().
% HINT.
%   1. Predict the class of the target image.
%   2. With N local activations, encode N Fisher vectors where each Fisher vector is encoded by each local activation.
%   3. Compute SVM score of each Fisher vector by using the pre-trained SVM of the predicted class.
%   4. Make a heat map with regions (i.e. rid2tlbr) and their SVM scores.
%   *Fully utilize the provided "svm" which contains "Db" as well as "NeuralRegnDscrber".
function map = genConfMap( iid, svm )
end