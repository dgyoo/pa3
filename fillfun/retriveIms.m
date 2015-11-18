% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
% This function retrieves similar images from a image database.
% INOUT.
%   iid:        Target image ID.
%   irdb:       [ N x numVector, matrix ] Image retrieval database matrix composed of N-dimensional image descriptors.
%   imDscrber:  Image describer.
% OUTPUT.
%   rank2iid:   [ numVector x 1, matrix ] i-th row has an image ID which is at ranking i.
% GIVEN FUNCTION.
%   None.
% HINT.
%   Define a (dis-)similarity maesure between a query vector and a DB vector such as the cosine similarity or Euclidean distance.
%   Fully utilize the provided "imDscrber" which contain "Db" as well as "NeuralDscrber" or "Fisher".
function rank2iid = retriveIms( iid, irdb, imDscrber )
end