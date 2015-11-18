% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
function setting = setChanges( setting, usersetting, processName )
    if ~isempty( usersetting )
        usernames = fieldnames( usersetting );
        usernames = sort( usernames );
        changes = [  ];
        for unidx = 1 : length( usernames )
            if isfield( setting, usernames{ unidx } )
                val = setting.( usernames{ unidx } );
                userval = usersetting.( usernames{ unidx } );
                if ~isempty( userval )
                    uservalstr = val2str( userval );
                    if length( uservalstr ) > 16
                        uservalstr = sum( ( uservalstr - 0 ) .* ( 1 : numel( uservalstr ) ) );
                        uservalstr = sprintf( '%010d', uservalstr );
                    else
                        uservalstr( uservalstr == '.' ) = 'P';
                    end
                    if issame( upper( val ), upper( userval ) )
                        fprintf( '%s: Already default: %s = %s\n', processName, usernames{ unidx }, uservalstr );
                    else
                        setting.( usernames{ unidx } ) = userval;
                        fprintf( '%s: Set to %s = %s\n', processName, usernames{ unidx }, uservalstr );
                        
                        pname = usernames{ unidx };
                        pname = strcat( pname( 1 ), pname( isstrprop( pname, 'upper' ) ) );
                        changes = cat( 2, changes, '_', upper( pname ), upper( uservalstr ) );
                    end
                end
            end
        end
        if ~isempty( changes )
            changes = changes( 2 : end );
        else
            changes = '';
        end
    else
        changes = '';
    end
    setting.changes = changes;
end