FROM obsidiandynamics/kafdrop:latest

ARG AWS_MSK_IAM_AUTH_VERSION=1.1.9
RUN wget -O "/`ls / | grep kafdrop-`/lib/aws-msk-iam-auth-${AWS_MSK_IAM_AUTH_VERSION}-all.jar" \
  https://github.com/aws/aws-msk-iam-auth/releases/download/v${AWS_MSK_IAM_AUTH_VERSION}/aws-msk-iam-auth-${AWS_MSK_IAM_AUTH_VERSION}-all.jar
