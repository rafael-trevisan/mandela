#!/bin/bash
#

INSTALL_DIR=$HOME/install
BINARIES_DIR=$INSTALL_DIR/binaries
SCRIPTS_DIR=$INSTALL_DIR/scripts
INSTALL_FILE=$BINARIES_DIR/oracle-xe-11.2.0-1.0.x86_64.rpm.zip
CONFIG_RSP=$SCRIPTS_DIR/xe.rsp
ORACLE_PWD=$1

cd $BINARIES_DIR
cat $INSTALL_FILE.* > $INSTALL_FILE
unzip $INSTALL_FILE
rm $INSTALL_FILE*
rpm -i Disk1/*.rpm
rm -rf Disk1/
sed -i -e "s|###ORACLE_PWD###|$ORACLE_PWD|g" $CONFIG_RSP
mv /usr/bin/free /usr/bin/free.bak
printf "#!/bin/sh\necho Swap - - 2048" > /usr/bin/free
chmod +x /usr/bin/free
/etc/init.d/oracle-xe configure responseFile=$CONFIG_RSP
rm /usr/bin/free
mv /usr/bin/free.bak /usr/bin/free
rm $CONFIG_RSP
echo "LISTENER = \
       (DESCRIPTION_LIST = \
         (DESCRIPTION = \
           (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC_FOR_XE)) \
           (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521)) \
         ) \
       ) \
     \
" > $ORACLE_HOME/network/admin/listener.ora
echo "DEDICATED_THROUGH_BROKER_LISTENER=ON"  >> $ORACLE_HOME/network/admin/listener.ora
echo "DIAG_ADR_ENABLED=OFF"  >> $ORACLE_HOME/network/admin/listener.ora
su -p oracle -c "sqlplus / as sysdba <<EOF
    EXEC DBMS_XDB.SETLISTENERLOCALACCESS(FALSE);
    ALTER DATABASE ADD LOGFILE GROUP 4 ('$ORACLE_BASE/oradata/$ORACLE_SID/redo04.log') SIZE 50m;
    ALTER DATABASE ADD LOGFILE GROUP 5 ('$ORACLE_BASE/oradata/$ORACLE_SID/redo05.log') SIZE 50m;
    ALTER DATABASE ADD LOGFILE GROUP 6 ('$ORACLE_BASE/oradata/$ORACLE_SID/redo06.log') SIZE 50m;
    ALTER DATABASE ADD LOGFILE GROUP 7 ('$ORACLE_BASE/oradata/$ORACLE_SID/redo07.log') SIZE 50m;
    ALTER DATABASE ADD LOGFILE GROUP 8 ('$ORACLE_BASE/oradata/$ORACLE_SID/redo08.log') SIZE 50m;
    ALTER DATABASE ADD LOGFILE GROUP 9 ('$ORACLE_BASE/oradata/$ORACLE_SID/redo09.log') SIZE 50m;
    ALTER SYSTEM SWITCH LOGFILE;
    ALTER SYSTEM SWITCH LOGFILE;
    ALTER SYSTEM CHECKPOINT;
    ALTER DATABASE DROP LOGFILE GROUP 1;
    ALTER DATABASE DROP LOGFILE GROUP 2;
    ALTER SYSTEM SET db_recovery_file_dest='';
    ALTER SYSTEM SET \"_disable_image_check\"=TRUE SCOPE=BOTH;
    EXIT;
EOF"
