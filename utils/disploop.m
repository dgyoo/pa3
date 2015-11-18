% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
function disploop( totiter, curriter, messg, cummt )
    fprintf( '(%.1f%%) %s', curriter * 100 / totiter, messg );
    [ d, h, m, s ] = myclock( cummt, curriter, totiter );
    if any( [ d, h, m, s ] ),
        fprintf( ' (' );
        if d, fprintf( '%dd', d ); end;
        if h, fprintf( '%dh', h ); end;
        if m, fprintf( '%dm', m ); end;
        if s, fprintf( '%ds', s ); end;
        fprintf( ')\n' );
    else
        fprintf( '\n' );
    end
end