ARG DOCKER_VERSION=stable
FROM docker:${DOCKER_VERSION}

# install glibc compatibility for alpine
ENV GLIBC_VER=2.35-r1

ENV GLIBC_FILE glibc-${GLIBC_VERSION}.apk
ENV GLIBC_BIN_FILE glibc-bin-${GLIBC_VERSION}.apk

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
    && rm /etc/apk/keys/sgerrand.rsa.pub \
    && rm -rf /var/cache/apk/*
# replace symlink to point to glibc version instead of musl version
RUN ln -sf /usr/glibc-compat/lib/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
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