ARG JDK_TAG=8-jdk-alpine
FROM openjdk:${JDK_TAG} AS kettle
LABEL MAINTAINER="Tien Tran <tientq@outlook.com>"

RUN apk add --update curl unzip

ARG PENTAHO_HOME=/opt/pentaho
ARG KETTLE_BINARY=${PENTAHO_HOME}/data-integration
ENV KETTLE_HOME=${PENTAHO_HOME}/data-integration

WORKDIR ${PENTAHO_HOME}

ARG PENTAHO_VERSION=9.3
ARG PENTAHO_BUILD_NUMBER=9.3.0.0-428
RUN curl -sL https://sourceforge.net/projects/pentaho/files/Pentaho-${PENTAHO_VERSION}/client-tools/pdi-ce-${PENTAHO_BUILD_NUMBER}.zip/download -o pdi-ce-${PENTAHO_BUILD_NUMBER}.zip
RUN unzip pdi-ce-${PENTAHO_BUILD_NUMBER}.zip && rm -Rf pdi-ce-9.3.0.0-428.zip pdi-ce-9.3.0.0-428.zip.sum

WORKDIR ${KETTLE_BINARY}

# install mysql driver
ARG MYSQL_DRIVER_VERSION=8.0.29
RUN curl -sfL https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_DRIVER_VERSION}/mysql-connector-java-${MYSQL_DRIVER_VERSION}.jar -o lib/mysql-connector-java-${MYSQL_DRIVER_VERSION}.jar

# install APMQ plugin
ARG PENTAHO_AMQP_VERSION=2.3.0
RUN curl -sfL https://github.com/AgoraData/PDI-Plugin-Step-AMQP/releases/download/${PENTAHO_AMQP_VERSION}/ic-amqp-plugin.zip -o ic-amqp-plugin.zip \
  && unzip ic-amqp-plugin.zip \
  && mv ic-amqp-plugin plugins/steps \
  && rm ic-amqp-plugin.zip

# install Google Sheets plugin
ARG PENTAHO_GOOGLE_SHEETS_VERSION=4.2
RUN curl -sfL https://github.com/jfmonteil/Pentaho-Google-Sheet-Plugin/archive/refs/heads/master.zip -o Pentaho-Google-Sheet-Plugin.zip \
  && unzip Pentaho-Google-Sheet-Plugin.zip \
  && unzip Pentaho-Google-Sheet-Plugin-master/delivery/PentahoGoogleSheetsPlugin-marketplace.zip \
  && mv PentahoGoogleSheetsPlugin-${PENTAHO_GOOGLE_SHEETS_VERSION} plugins/steps \
  && rm -Rf Pentaho-Google-Sheet-Plugin-master Pentaho-Google-Sheet-Plugin.zip

FROM kettle AS carte
ADD docker-entrypoint.sh docker-entrypoint.sh
RUN chmod +x docker-entrypoint.sh

EXPOSE 8080

ENTRYPOINT [ "./docker-entrypoint.sh" ]
CMD [ "master" ]