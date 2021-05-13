FROM nginx:1.20

ARG ENVSUBST_VERSION=1.2.0
RUN curl -sL "https://github.com/a8m/envsubst/releases/download/v${ENVSUBST_VERSION}/envsubst-Linux-x86_64" -o /usr/local/bin/envsubst && \
    chmod +x /usr/local/bin/envsubst

ADD templates /etc/nginx/templates
