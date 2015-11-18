% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
function [ d, h, m, s ] = myclock( cummt, curriter, totiter )
    remain = ( cummt / curriter ) * ( totiter - curriter );
    d = floor( remain / ( 24 * 3600 ) );
    remain = remain - d * 24 * 3600;
    h = floor( remain / 3600 );
    remain = remain - h * 3600;
    m = floor( remain / 60 );
    remain = remain - m * 60;
    s = floor( remain );
end