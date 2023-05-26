ARG DOCKER_VERSION=stable
FROM docker:${DOCKER_VERSION}

# install glibc compatibility for alpine
# Must be provided: x86_64, armhf or aarch64
ARG ARCH=x86_64
ENV GLIBC_VER=2.35-r1

ENV GLIBC_FILE glibc-${GLIBC_VERSION}-${ARCH}.apk
ENV GLIBC_BIN_FILE glibc-bin-${GLIBC_VERSION}-${ARCH}.apk

RUN apk --no-cache add \
        binutils \
        curl \
    && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/${GLIBC_FILE} \
    && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/${GLIBC_BIN_FILE} \
    && apk add --no-cache \
        ${GLIBC_FILE} \
        ${GLIBC_BIN_FILE} \
    && rm ${GLIBC_FILE} \
    && rm ${GLIBC_BIN_FILE} \
    && rm -rf /var/cache/apk/*
RUN docker -v

RUN apk add --no-cache \
        python3 \
        py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache-dir \
        awscli \
    && rm -rf /var/cache/apk/*
RUN aws --version

RUN apk --no-cache add \
        openjdk11-jdk \
        maven \
        nodejs npm \
    && rm -rf /var/cache/apk/*
RUN java -version
RUN mvn -v
RUN node -v