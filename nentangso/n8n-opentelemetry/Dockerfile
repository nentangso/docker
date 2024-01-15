ARG N8N_VERSION=latest
FROM n8nio/n8n:${N8N_VERSION}
LABEL Maintainer "Tran Quang Tien (SA) <tranquangtien.sa@gmail.com>"

USER root
RUN npm install -g \
  @opentelemetry/sdk-node \
  @opentelemetry/api \
  @opentelemetry/auto-instrumentations-node \
  @opentelemetry/sdk-metrics \
  @opentelemetry/sdk-trace-node

ADD instrumentation.js /usr/local/lib/instrumentation.js
RUN sed -i "s|require('@oclif/command')|require('/usr/local/lib/instrumentation');\nrequire('@oclif/command')|g" /usr/local/lib/node_modules/n8n/bin/n8n

USER node