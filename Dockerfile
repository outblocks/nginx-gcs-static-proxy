FROM nginx:1.21

ARG GUCCI_VERSION=1.5.0
RUN curl -sL https://github.com/noqcks/gucci/releases/download/${GUCCI_VERSION}/gucci-v${GUCCI_VERSION}-linux-amd64 -o /usr/local/bin/gucci && \
    chmod +x /usr/local/bin/gucci

COPY templates /etc/nginx/templates
COPY docker-entrypoint.d /docker-entrypoint.d
COPY nginx.conf /etc/nginx/nginx.conf
COPY gcs.conf /etc/nginx/gcs.conf
