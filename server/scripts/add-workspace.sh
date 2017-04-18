#!/bin/bash
#

su -p oracle -c "sqlplus / as sysdba <<EOF
ALTER SESSION SET CURRENT_SCHEMA = APEX_050100;

DROP USER HR CASCADE;

CREATE USER MANDELA IDENTIFIED BY MANDELA;

DECLARE
    l_workspace_id number;
BEGIN
    APEX_INSTANCE_ADMIN.ADD_WORKSPACE (
        p_workspace_id => NULL,
        p_workspace => 'MANDELA',
        p_primary_schema => 'MANDELA'
    );

    SELECT to_char(workspace_id)
    INTO l_workspace_id
    FROM apex_workspaces
    WHERE workspace = 'MANDELA';

    APEX_UTIL.SET_SECURITY_GROUP_ID (p_security_group_id => l_workspace_id);

    APEX_UTIL.CREATE_USER(
        p_user_name                     => 'ADMIN',
        p_first_name                    => '',
        p_last_name                     => '',
        p_description                   => '',
        p_email_address                 => 'ADMIN',
        p_web_password                  => 'S3cR3t!',
        p_developer_privs               => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
        p_default_schema                => 'MANDELA',
        p_allow_access_to_schemas       => NULL,
        p_change_password_on_first_use  => 'N'
    );

    COMMIT;
END;
/

EXIT;

EOF"
