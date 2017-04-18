Rem  Copyright (c) Oracle Corporation 2011 - 2013. All Rights Reserved.
Rem
Rem    NAME
Rem      apex_rest_config_nocdb.sql
Rem
Rem    DESCRIPTION
Rem      This script creates the APEX_LISTENER and APEX_REST_PUBLIC_USER database users:
Rem        - The APEX_LISTENER user is used by Oracle REST Data Services to access the schema objects in the
Rem          APEX_XXXXXX schema containing resource templates and OAuth data. This user is NOT used for execution of
Rem          resource templates or APEX sessions.
Rem        - The APEX_REST_PUBLIC_USER user is used for the execution of resource templates or APEX sessions.
Rem
Rem    NOTES
Rem      Assumes the SYS user is connected. You will be prompted to enter passwords for both users.
Rem
Rem    REQUIRMENTS
Rem
Rem    MODIFIED   (MM/DD/YYYY)
Rem    cdivilly   09/07/2011 - Created
Rem    hfarrell   09/13/2011 - Updated grants to apex_listener to be limited to select, insert, update and delete
Rem    hfarrell   09/14/2011 - Renamed file from apex_listener to restconf.sql
Rem    cneumuel   09/14/2011 - Added grant execute on wwv_flow_listener
Rem    hfarrell   09/14/2011 - Updated references to APPUN
Rem    pawolf     09/16/2011 - Updated table names and added new grants and synonyms
Rem    hfarrell   09/20/2011 - Updated to reset password for user APEX_REST_PUBLIC_USER
Rem    hfarrell   09/20/2011 - Added grant connect session to APEX_REST_PUBLIC_USER-required by Colm
Rem    hfarrell   09/22/2011 - Updated the creation statement for APEX_LISTENER user to unlock account and remove trailing
Rem                            semi colon after statement
Rem    hfarrell   09/26/2011 - Added synonyms on the three views: wwv_flow_rt$apex_account_privs, wwv_flow_rt$idm_privs
Rem                            and wwv_flow_rt$services
Rem    hfarrell   09/27/2011 - Added call to wwv_flow_listener.install_seed_data for inserting SQL Developer seed data
Rem    hfarrell   10/14/2011 - Added grants and new synonym on new table wwv_flow_rt$user_sessions
Rem    hfarrell   10/20/2011 - Added DROP statements for users APEX_LISTENER and APEX_REST_PUBLIC_USER
Rem    pawolf     02/21/2012 - Changed APEX_040100 references to APEX_040200
Rem    hfarrell   03/06/2012 - Added grant on ^APPUN..vc4000array to apex_listener - as added for cloud in dbpod_restful_conf.sql
Rem                            and associated synonym (bug 13819620)
Rem    hfarrell   06/05/2012 - Added explicit commit after creating SQL Developer seed data
Rem    hfarrell   06/05/2012 - Added setting of preference RESTFUL_SERVICES_ENABLED to Yes
Rem    vuvarov    06/05/2012 - Removed SQL Developer seed data
Rem    hfarrell   06/11/2012 - Added creation of RESTful Services and OAuth2 Client Developer user groups - for the Cloud they are created with SQL Developer seed data
Rem    hfarrell   06/22/2012 - Reposition alter session statement to before creation of RESTful user groups
Rem    hfarrell   07/12/2012 - Removed setting of system preference RESTFUL_SERVICES_ENABLED, as now available in default APEX install
Rem    hfarrell   07/16/2012 - Added pool_config synonym and select to APEX_LISTENER
Rem    hfarrell   09/11/2012 - Added synonym and associated grant on wwv_flow_rt$pending_approvals
Rem    jkallman   12/17/2012 - Changed APEX_040200 references to APEX_050000
Rem    hfarrell   03/13/2013 - Added call to wwv_flow_listener.install_prereq_data for inserting SQL Dev client registration and user groups (bug #16483083)
Rem    hfarrell   03/13/2013 - Removed group creation statements, as now handled in install_prereq_data (bug #16483083)
Rem    cneumuel   03/19/2013 - Added wwv_flow_lsnr_workspaces, wwv_flow_lsnr_applications, wwv_flow_lsnr_entry_points (bug #16513444)
Rem    cneumuel   04/26/2013 - ^APPUN..vc4000array renamed to ^APPUN..wwv_flow_t_varchar2, but synonym stays the same, for compatibility
Rem    hfarrell   05/31/2013 - Added synonym and associated grants for wwv_flow_rt$privilege_groups (bug #16889920)
Rem    hfarrell   03/03/2014 - Replaced reference to APEX Listener with Oracle REST Data Services in header information
Rem    jstraub    12/01/2014 - Modified to call either apex_rest_config_cdb.sql or apex_rest_config_core.sql
Rem    jstraub    12/03/2014 - Moved invocation of apxpreins.sql before prompts
Rem    jstraub    04/10/2015 - Split from apex_rest_config.sql (bug 20689402)
Rem    msewtz     07/07/2015 - Changed APEX_050000 references to APEX_050100

set define '^'
set concat on
set concat .
set verify off
set autocommit off

define APPUN = 'APEX_050100'
define LISTENERUN = 'APEX_LISTENER'
define RESTUN = 'APEX_REST_PUBLIC_USER'
define PASSWD1 = '###ORDS_PWD###'
define PASSWD2 = '###ORDS_PWD###'

-- Prompt user for the password for the Listener user
Rem accept PASSWD1 CHAR prompt 'Enter a password for the ^LISTENERUN. user              [] ' HIDE

-- Prompt user for the password for the REST user
Rem accept PASSWD2 CHAR prompt 'Enter a password for the ^RESTUN. user              [] ' HIDE


@@apex_rest_config_core.sql ^PASSWD1 ^PASSWD2
