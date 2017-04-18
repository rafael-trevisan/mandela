#!/bin/bash
#
ORACLE_PWD=secret
ORDS_PWD=S3cR3t!

chmod u+x /root/install/scripts/*.sh
chmod u+x /entrypoint.sh
root/install/scripts/install-oracle.sh $ORACLE_PWD
root/install/scripts/remove-apex.sh
root/install/scripts/install-apex.sh $ORACLE_PWD $ORDS_PWD
root/install/scripts/install-ords.sh
root/install/scripts/add-workspace.sh
root/install/scripts/import-app.sh
/etc/init.d/oracle-xe stop
rm -rf /root/install/
rm -rf /tmp/*
