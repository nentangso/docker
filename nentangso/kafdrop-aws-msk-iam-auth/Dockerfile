FROM obsidiandynamics/kafdrop:3.31.0

ARG KAFDROP_VERSION=3.31.0
ARG AWS_MSK_IAM_AUTH_VERSION=1.1.9

WORKDIR "/kafdrop-${KAFDROP_VERSION}"
RUN cp kafdrop-${KAFDROP_VERSION}.jar kafdrop-${KAFDROP_VERSION}-original.jar \
  && mkdir -p BOOT-INF/lib \
  && wget -O "BOOT-INF/lib/aws-msk-iam-auth-${AWS_MSK_IAM_AUTH_VERSION}-all.jar" \
    https://github.com/aws/aws-msk-iam-auth/releases/download/v${AWS_MSK_IAM_AUTH_VERSION}/aws-msk-iam-auth-${AWS_MSK_IAM_AUTH_VERSION}-all.jar \
  && jar -uf0 kafdrop-${KAFDROP_VERSION}.jar BOOT-INF/lib/aws-msk-iam-auth-${AWS_MSK_IAM_AUTH_VERSION}-all.jar \
  && rm -rf BOOT-INF