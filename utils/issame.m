% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
function is = issame( A, B )
    if ischar( A ) && ischar( B )
        is = strcmp( A, B );
    elseif isnumeric( A ) && isnumeric( B )
        is = isequal( A, B );
    elseif islogical( A ) && islogical( B )
        is = A == B;
    elseif isa( A, 'function_handle' ) && isa( B, 'function_handle' )
        A = func2str( A );
        B = func2str( B );
        is = issame( A, B );
    else
        error( 'Matrix, string, boolean and function_handle are supported only.\n' );
    end
end