ARG N8N_VERSION=latest
FROM n8nio/n8n:${N8N_VERSION}
LABEL Maintainer "Tran Quang Tien (SA) <tranquangtien.sa@gmail.com>"

USER root

RUN npm install -g \
  @opentelemetry/api \
  @opentelemetry/auto-instrumentations-node

RUN sed -i "s|require('@oclif/command')|require('@opentelemetry/auto-instrumentations-node/register');\nrequire('@oclif/command')|g" /usr/local/lib/node_modules/n8n/bin/n8n

USER node