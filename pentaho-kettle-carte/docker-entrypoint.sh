#!/bin/sh
set -e

: ${EXT_DIR:="/pdi-ext"}

: ${PDI_HADOOP_CONFIG:="hdp25"}

: ${PDI_MAX_LOG_LINES:="10000"}
: ${PDI_MAX_LOG_TIMEOUT:="1440"}
: ${PDI_MAX_OBJ_TIMEOUT:="240"}

: ${SERVER_NAME:="`hostname`"}
: ${SERVER_HOST:="`hostname`"}
: ${SERVER_PORT:="8080"}
: ${SERVER_SSL_MODE:="N"}
: ${SERVER_USER:="admin"}
: ${SERVER_PASSWORD:=""}

: ${MASTER_NAME:="pdi-master"}
: ${MASTER_HOST:="localhost"}
: ${MASTER_PORT:="8080"}
: ${MASTER_CONTEXT:=""}
: ${MASTER_SSL_MODE:="N"}
: ${MASTER_USER:="admin"}
: ${MASTER_PASSWORD:="password"}

: ${KETTLE_REPOSITORY:="pentaho_repository"}
: ${KETTLE_USER:="admin"}
: ${KETTLE_PASSWORD:="admin"}

: ${KETTLE_PROPERTIES_READ_ONLY:="N"}

_gen_password() {
  echo "Generating encrypted password..."
  if [[ "$SERVER_PASSWORD" == "" ]]; then
    _ADMIN_PWD="$(dd if=/dev/urandom bs=255 count=1 | tr -dc 'a-zA-Z0-9' | fold -w $((96 + RANDOM % 32)) | head -n 1)"
  else
    _ADMIN_PWD="$SERVER_PASSWORD"
  fi

  [[ "$DEBUG" ]] && echo "=> [$_ADMIN_PWD]"

  if [[ $_ADMIN_PWD == Encrypted* ]]; then
    SERVER_PASSWORD="$_ADMIN_PWD"
  else
    SERVER_PASSWORD=$(./encr.sh -kettle $_ADMIN_PWD | tail -1)
  fi

  _ADMIN_PWD=""
}

gen_rest_conf() {
  # unset doesn't work
  echo "Clean up sensitive environment variabiles..."
  SERVER_PASSWORD=""
  MASTER_PASSWORD=""
  _KS_PWD=""
  _KEY_PWD=""
  export SERVER_PASSWORD MASTER_PASSWORD

  if [ ! -f $KETTLE_HOME/.kettle/kettle.properties ]; then
    test -d $KETTLE_HOME/.kettle || mkdir -p $KETTLE_HOME/.kettle
    echo "Generating kettle.properties..."
    cat << EOF > $KETTLE_HOME/.kettle/kettle.properties
# This file was generated by Pentaho Data Integration.
#
# Here are a few examples of variables to set:
#
# PRODUCTION_SERVER = hercules
# TEST_SERVER = zeus
# DEVELOPMENT_SERVER = thor
#
# Note: lines like these with a # in front of it are comments
#
# Read more at https://github.com/pentaho/pentaho-kettle/blob/6.1.0.1-R/engine/src/kettle-variables.xml
KETTLE_EMPTY_STRING_DIFFERS_FROM_NULL=Y
KETTLE_DISABLE_CONSOLE_LOGGING=N
KETTLE_FORCED_SSL=N
# Master Detector ( start in 1 second, and repeat detection every 10 seconds)
KETTLE_MASTER_DETECTOR_INITIAL_DELAY=1000
KETTLE_MASTER_DETECTOR_REFRESH_INTERVAL=10000
KETTLE_REDIRECT_STDERR=Y
KETTLE_REDIRECT_STDOUT=Y
KETTLE_SYSTEM_HOSTNAME=${SERVER_HOST}
# Less memory consumption, hopefully
KETTLE_STEP_PERFORMANCE_SNAPSHOT_LIMIT=1
# Tracing
#KETTLE_TRACING_ENABLED=Y
#KETTLE_TRACING_HTTP_URL=http://localhost:9411
EOF
  fi
  if [ ! -f classes/log4j.xml ]; then
    mkdir -p classes
    echo "Generating log4j.xml..."
    cat << EOF > classes/log4j.xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE log4j:configuration SYSTEM "log4j.dtd">
<log4j:configuration xmlns:log4j="http://jakarta.apache.org/log4j/" debug="false">
  <!-- ================================= -->
  <!-- Preserve messages in a local file -->
  <!-- ================================= -->
  <appender name="PENTAHOFILE" class="org.apache.log4j.RollingFileAppender">
    <param name="File" value="logs/pdi.log"/>
    <param name="Append" value="true"/>
    <param name="MaxFileSize" value="10MB"/>
    <param name="MaxBackupIndex" value="5"/>
    <layout class="org.apache.log4j.PatternLayout">
      <param name="ConversionPattern" value="%d %-5p [%c] %m%n"/>
    </layout>
  </appender>
  <!-- ================ -->
  <!-- Limit categories -->
  <!-- ================ -->
  <category name="org.pentaho.di">
    <priority value="INFO" />
  </category>
  <category name="org.pentaho.platform.osgi">
    <priority value="INFO" />
  </category>
  <category name="org.pentaho.platform.engine.core.system.status">
    <priority value="INFO"/>
  </category>
  <!-- ======================= -->
  <!-- Setup the Root category -->
  <!-- ======================= -->
  <root>
    <priority value="ERROR" />
    <appender-ref ref="PENTAHOFILE"/>
  </root>
</log4j:configuration>
EOF
  fi
}

gen_slave_config() {
  # check if configuration file exists
  if [ ! -f pwd/slave.xml ]; then
    echo "Generating slave server configuration..."
    _gen_password

    if [[ ! $MASTER_PASSWORD == Encrypted* ]]; then
      MASTER_PASSWORD=$(./encr.sh -kettle $MASTER_PASSWORD | tail -1)
    fi

    # this is tricky as encr.sh will generate kettle.properties without required configuration
    [[ "$KETTLE_PROPERTIES_READ_ONLY" != "Y" ]] && rm -f $KETTLE_HOME/.kettle/kettle.properties
    
    cat << EOF > pwd/slave.xml
<slave_config>
    <masters>
        <slaveserver>
            <name>${MASTER_NAME}</name>
            <hostname>${MASTER_HOST}</hostname>
            <port>${MASTER_PORT}</port>
            <webAppName>${MASTER_CONTEXT}</webAppName>
            <username>${MASTER_USER}</username>
            <password>${MASTER_PASSWORD}</password>
            <master>Y</master>
            <sslMode>${MASTER_SSL_MODE}</sslMode>
        </slaveserver>
    </masters>
    <report_to_masters>Y</report_to_masters>
    <slaveserver>
        <name>${SERVER_NAME}</name>
        <hostname>${SERVER_HOST}</hostname>
        <port>${SERVER_PORT}</port>
        <username>${SERVER_USER}</username>
        <password>${SERVER_PASSWORD}</password>
        <master>N</master>
        <sslMode>${SERVER_SSL_MODE}</sslMode>
        <get_properties_from_master>${MASTER_NAME}</get_properties_from_master>
        <override_existing_properties>Y</override_existing_properties>
    </slaveserver>
    <max_log_lines>${PDI_MAX_LOG_LINES}</max_log_lines>
    <max_log_timeout_minutes>${PDI_MAX_LOG_TIMEOUT}</max_log_timeout_minutes>
    <object_timeout_minutes>${PDI_MAX_OBJ_TIMEOUT}</object_timeout_minutes>
</slave_config>
EOF
  fi
}

gen_master_config() {
  # check if configuration file exists
  if [ ! -f pwd/master.xml ]; then
    echo "Generating master server configuration..."
    _gen_password

    [[ "$KETTLE_PROPERTIES_READ_ONLY" != "Y" ]] && rm -f $KETTLE_HOME/.kettle/kettle.properties

    cat << EOF > pwd/master.xml
<slave_config>
    <slaveserver>
        <name>${SERVER_NAME}</name>
        <hostname>${SERVER_HOST}</hostname>
        <port>${SERVER_PORT}</port>
        <username>${SERVER_USER}</username>
        <password>${SERVER_PASSWORD}</password>
        <master>Y</master>
        <sslMode>${SERVER_SSL_MODE}</sslMode>
    </slaveserver>
    <repository>
      <name>${KETTLE_REPOSITORY}</name>
      <username>${KETTLE_USER}</username>
      <password>${KETTLE_PASSWORD}</password>
    </repository>
    <report_to_masters>Y</report_to_masters>
    <max_log_lines>${PDI_MAX_LOG_LINES}</max_log_lines>
    <max_log_timeout_minutes>${PDI_MAX_LOG_TIMEOUT}</max_log_timeout_minutes>
    <object_timeout_minutes>${PDI_MAX_OBJ_TIMEOUT}</object_timeout_minutes>
</slave_config>
EOF
  fi
}

# run as slave server
if [ "$1" = 'slave' ]; then
  gen_slave_config
  gen_rest_conf
  
  # update configuration based on environment variables
  # send log output to stdout
  #sed -i 's/^\(.*rootLogger.*\), *out *,/\1, stdout,/' system/karaf/etc/org.ops4j.pax.logging.cfg
  #sed -i -e 's|.*\(runtimeFeatures=\).*|\1'"ssh,http,war,kar,cxf"'|' system/karaf/etc-carte/org.pentaho.features.cfg 

  # now start the PDI server
  echo "Starting Carte as slave server..."
  exec ./carte.sh pwd/slave.xml
elif [ "$1" = 'master' ]; then
  gen_master_config
  gen_rest_conf
  
  # now start the PDI server
  echo "Starting Carte as master server..."
  exec ./carte.sh pwd/master.xml
else
  _gen_password
  exec ./carte.sh "$@"
fi