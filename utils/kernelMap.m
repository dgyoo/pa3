% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
function [ vecs ] = kernelMap( vecs, type )
    switch upper( type )
        case 'NONE'
        case 'HELL'
            vecs = sign( vecs ) .* sqrt( abs( vecs ) );
        case 'HELL2'
            vecs = sign( vecs ) .* sqrt( sqrt( abs( vecs ) ) );
        case 'CHI2'
            vecs = vl_homkermap( vecs, 1, 'kchi2' );
        case 'POW2'
            vecs = sign( vecs ) .* vecs .^ 2;
        otherwise
            error( 'Err: no such kernel: %s\n', type );
    end
end

