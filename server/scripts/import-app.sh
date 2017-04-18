#!/bin/bash
#

su -p oracle -c "sqlplus / as sysdba <<EOF
declare
    l_workspace_id number;
begin
    select workspace_id into l_workspace_id
      from apex_workspaces
     where workspace = 'MANDELA';
    --
    apex_application_install.set_workspace_id( l_workspace_id );
    apex_application_install.generate_offset;
    apex_application_install.set_schema( 'MANDELA' );
    apex_application_install.set_application_alias( 'MANDELA' );
end;
/

@/tmp/f100.sql

EOF"
