FROM rabbitmq:3.8-management-alpine

RUN apk add --update \
    curl \
    && rm -rf /var/cache/apk/*
ARG DELAYED_MESSAGE_EXCHANGE_DOWNLOAD_URL="https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/3.8.9/rabbitmq_delayed_message_exchange-3.8.9-0199d11c.ez"
RUN curl -sf -o /opt/rabbitmq/plugins/rabbitmq_delayed_message_exchange-3.8.x.ez -L ${DELAYED_MESSAGE_EXCHANGE_DOWNLOAD_URL}
RUN rabbitmq-plugins enable --offline rabbitmq_web_stomp rabbitmq_delayed_message_exchange