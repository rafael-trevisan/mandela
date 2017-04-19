FROM oraclelinux:7-slim
MAINTAINER Rafael Trevisan <rafael@trevis.ca>

# Install Operating System
RUN yum -y install unzip libaio bc initscripts net-tools java && \
    yum -y update && \
    yum clean all

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV ORACLE_BASE=/u01/app/oracle \
    ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe \
    ORACLE_SID=XE

# Use second ENV so that variable get substituted
ENV PATH=$ORACLE_HOME/bin:$PATH \
    SHM_SIZE="1G" 

# Copy binaries
# -------------
ADD server/binaries/ /root/install/binaries/
ADD server/scripts/ /root/install/scripts/
ADD source/ /tmp/
ADD server/scripts/entrypoint.sh /

# Install Oracle Database Express Edition
# ---------------------------------------
RUN chmod u+x /root/install/scripts/install-server.sh && \
    exec /root/install/scripts/install-server.sh

EXPOSE 1521 8080

ENTRYPOINT ["/entrypoint.sh"]
