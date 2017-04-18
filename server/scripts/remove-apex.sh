#!/bin/bash
#

APEX_HOME=$ORACLE_HOME/apex

su -p oracle -c "sqlplus / as sysdba @$APEX_HOME/apxremov.sql"
