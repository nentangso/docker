ARG KAFKA_CONNECT_VERSION=7.3.1
FROM confluentinc/cp-kafka-connect:$KAFKA_CONNECT_VERSION

ARG CONNECTOR_TRANSFORMS_VERSION=1.4.3
RUN confluent-hub install --no-prompt confluentinc/connect-transforms:$CONNECTOR_TRANSFORMS_VERSION

ARG CONNECTOR_DEBEZIUM_VERSION=2.0.1
RUN confluent-hub install --no-prompt debezium/debezium-connector-mysql:$CONNECTOR_DEBEZIUM_VERSION
RUN confluent-hub install --no-prompt debezium/debezium-connector-postgresql:$CONNECTOR_DEBEZIUM_VERSION
RUN confluent-hub install --no-prompt debezium/debezium-connector-sqlserver:$CONNECTOR_DEBEZIUM_VERSION
RUN confluent-hub install --no-prompt debezium/debezium-connector-mongodb:$CONNECTOR_DEBEZIUM_VERSION

ARG CONNECTOR_JDBC_VERSION=10.6.3
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:$CONNECTOR_JDBC_VERSION

ARG CONNECTOR_BIGQUERY_VERSION=2.4.4
RUN confluent-hub install --no-prompt wepay/kafka-connect-bigquery:$CONNECTOR_BIGQUERY_VERSION

ARG CONNECTOR_ELASTICSEARCH_VERSION=14.0.5
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-elasticsearch:$CONNECTOR_ELASTICSEARCH_VERSION