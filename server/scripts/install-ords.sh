#!/bin/bash
#

INSTALL_DIR=/root/install
BINARIES_DIR=$INSTALL_DIR/binaries
SCRIPTS_DIR=$INSTALL_DIR/scripts
INSTALL_FILE=$BINARIES_DIR/ords.3.0.9.348.07.16.zip
PARAMS_FILE=$SCRIPTS_DIR/ords_params.properties
ORDS_HOME=$ORACLE_BASE/ords

cd $BINARIES_DIR
mkdir -p $ORDS_HOME
cat $INSTALL_FILE.* > $INSTALL_FILE
unzip -o $INSTALL_FILE -d $ORDS_HOME
rm $INSTALL_FILE*
mv $PARAMS_FILE $ORDS_HOME/params
cd $ORDS_HOME
java -jar ords.war configdir $ORACLE_BASE
java -jar ords.war install simple
sed -i -e 's|<entry key="jdbc.MaxLimit">10</entry>|<entry key="jdbc.MaxLimit">20</entry>|g' defaults.xml
sed -i -e 's|<entry key="jdbc.InitialLimit">3</entry>|<entry key="jdbc.InitialLimit">6</entry>|g' defaults.xml

# cp -rf $ORDS_HOME/ords.war /usr/share/tomcat/webapps/
# cp -rf $ORACLE_HOME/apex/images /usr/share/tomcat/webapps/i
