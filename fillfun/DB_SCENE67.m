% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
% This function computes the dataset informations.
% INOUT.
%   None.
% OUTPUT.
% 	cid2name:   [ numClass x 1, cell ] Class ID to class name: i-th row has the class name of i-th class.
% 	iid2impath: [ numImage x 1, cell ] Image ID to image path. i-th row has the image path of i-th image.
% 	iid2size:   [ 2 x numImage matrix ] Image ID to image size. i-th column has the image size of i-th image in the order of [ numRow; numColumn; ].
%   iid2setid:  [ numImage x 1, matrix ] Image ID to set ID. i-th row has the set ID of i-th image. 
%               Set ID is 1 for training, or 2 for test. Just follow "TrainImages.txt" and "TestImages.txt" in the downloaded dataset.
%   iid2cid:    [ numImage x 1, matrix ] Image ID to class ID. i-th row has the class ID of i-th image. 
%   oid2diff:   Ignore.
%   oid2iid:    Ignore.
%   oid2bbox:   Ignore.
%   oid2cont:   Ignore.
% GIVEN FUNCTION.
%   None.
% HINT.
%   Utilize the global variable "path" which is defined in "init.m".
function [  cid2name, ...
            iid2impath, ...
            iid2size, ...
            iid2setid, ...
            iid2cid, ...
            oid2diff, ...
            oid2iid, ...
            oid2bbox, ...
            oid2cont ] = DB_SCENE67
    global path;    
    % Fill here.
    % ...
    
    % DO NOT TOUCH the following!
    oid2diff = false( size( iid2impath ) );
    oid2iid = ( 1 : numel( iid2impath ) )';
    oid2bbox = cat( 1, ones( 2, numel( iid2impath ) ), iid2size );
    oid2cont = cell( size( iid2cid ) );
end