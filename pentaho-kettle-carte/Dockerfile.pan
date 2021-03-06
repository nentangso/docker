FROM kettle AS pan

ENV KETTLE_REPOSITORY=
ENV KETTLE_USER=
ENV KETTLE_PASSWORD=
ENV KETTLE_DIR=
ENV KETTLE_TRANS=
ENV KETTLE_LOGGING_LEVEL=Basic
ENV KETTLE_MAX_LOG_LINES=10000
ENV KETTLE_MAX_LOG_TIMEOUT=4320
ENV KETTLE_EXTRA_ARGS=

ENTRYPOINT [ "/opt/pentaho/data-integration/pan.sh" ]
CMD -rep=${KETTLE_REPOSITORY} -user=${KETTLE_USER} -pass=${KETTLE_PASSWORD} -dir=${KETTLE_DIR} -trans=${KETTLE_TRANS} -level=${KETTLE_LOGGING_LEVEL} -maxloglines=${KETTLE_MAX_LOG_LINES} -maxlogtimeout=${KETTLE_MAX_LOG_TIMEOUT} ${KETTLE_EXTRA_ARGS}