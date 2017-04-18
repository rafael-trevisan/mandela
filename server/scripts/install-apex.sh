#!/bin/bash
#

INSTALL_DIR=/root/install
BINARIES_DIR=$INSTALL_DIR/binaries
SCRIPTS_DIR=$INSTALL_DIR/scripts
INSTALL_FILE=$BINARIES_DIR/apex_5.1.1_en.zip
CONFIG_RSP=$SCRIPTS_DIR/xe.rsp
ORACLE_PWD=$1
ORDS_PWD=$2
APEX_HOME=$ORACLE_HOME/apex

cd $BINARIES_DIR
cat $INSTALL_FILE.* > $INSTALL_FILE
unzip -o $INSTALL_FILE -d $ORACLE_HOME
rm $INSTALL_FILE*
sed -i -e "s|###ORDS_PWD###|$ORDS_PWD|g" $SCRIPTS_DIR/apxchpwd.sql
sed -i -e "s|###ORDS_PWD###|$ORDS_PWD|g" $SCRIPTS_DIR/apex_rest_config_nocdb.sql
sed -i -e "s|###ORDS_PWD###|$ORDS_PWD|g" $SCRIPTS_DIR/ords_params.properties
sed -i -e "s|###ORACLE_PWD###|$ORACLE_PWD|g" $SCRIPTS_DIR/ords_params.properties
mv $SCRIPTS_DIR/apxchpwd.sql $APEX_HOME
mv $SCRIPTS_DIR/apex_rest_config_nocdb.sql $APEX_HOME
cd $APEX_HOME
su -p oracle -c "sqlplus / as sysdba @apexins SYSAUX SYSAUX TEMP /i/"
su -p oracle -c "sqlplus / as sysdba <<EOF
@apxchpwd.sql
ALTER USER APEX_PUBLIC_USER IDENTIFIED BY \""$ORDS_PWD\"" ACCOUNT UNLOCK;
EXEC DBMS_XDB.SETHTTPPORT(0);
@apex_rest_config.sql
EOF"
