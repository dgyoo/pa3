% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
function [ str ] = val2str( val )
    if ischar( val )
        str = val;
    elseif isnumeric( val )
        if length( val ) <= 1
            str = num2str( val );
        else
            str = mat2str( val );
        end
    elseif islogical( val )
        str = num2str( val );
    elseif isa( val, 'function_handle' )
        str = func2str( val );
    else
        error( 'only matrix, string, boolean are supported.\n' );
    end
end