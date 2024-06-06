FROM rabbitmq:3.13-management-alpine

RUN apk add --update \
    curl \
    && rm -rf /var/cache/apk/*
ARG DELAYED_MESSAGE_EXCHANGE_DOWNLOAD_URL="https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/v3.13.0/rabbitmq_delayed_message_exchange-3.13.0.ez"
RUN curl -sf -o /opt/rabbitmq/plugins/rabbitmq_delayed_message_exchange-3.13.x.ez -L ${DELAYED_MESSAGE_EXCHANGE_DOWNLOAD_URL}
RUN rabbitmq-plugins enable --offline \
    rabbitmq_mqtt \
    rabbitmq_web_mqtt \
    rabbitmq_web_stomp \
    rabbitmq_delayed_message_exchange