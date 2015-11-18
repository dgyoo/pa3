% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
function vecs = nmlzVecs( vecs, type )
    switch upper( type )
        case 'NONE'
        case 'L1'
            vecs = bsxfun( @times, vecs, 1 ./ sum( vecs ) );
        case 'L2'
            vecs = bsxfun( @times, vecs, 1 ./ max( sqrt( sum( vecs .^ 2 ) ), 1e-12 ) );
        otherwise
            error( 'Err: no such norm: %s\n', type );
    end
end