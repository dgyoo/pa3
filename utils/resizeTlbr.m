% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
function tlbr = resizeTlbr( tlbr, srcDomainSize, dstDomainSize )
    srcDomainSize = srcDomainSize( : );
    dstDomainSize = dstDomainSize( : );
    slop = ( dstDomainSize - 1 ) ./ ( srcDomainSize - 1 ); % RC
    tlbr( [ 1, 3 ], : ) = slop( 1 ) * ( tlbr( [ 1, 3 ], : ) - 1 ) + 1;
    tlbr( [ 2, 4 ], : ) = slop( 2 ) * ( tlbr( [ 2, 4 ], : ) - 1 ) + 1;
end