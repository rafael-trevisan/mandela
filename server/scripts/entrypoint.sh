#!/bin/sh

########### SIGTERM handler ############
function _term() {
   echo "Stopping container."
   echo "SIGTERM received, shutting down database!"
  /etc/init.d/oracle-xe stop
}

########### SIGKILL handler ############
function _kill() {
   echo "SIGKILL received, shutting down database!"
   /etc/init.d/oracle-xe stop
}

# Set SIGTERM handler
trap _term SIGTERM

# Set SIGKILL handler
trap _kill SIGKILL

# Start Oracle XE
/etc/init.d/oracle-xe start
java -jar /u01/app/oracle/ords/ords.war standalone &
echo "#############################"
echo "MANDELA IS READY TO USE!"
echo "Open http://localhost:<port>"
echo "#############################"
tail -f $ORACLE_BASE/diag/rdbms/*/*/trace/alert*.log &
childPID=$!
wait $childPID
