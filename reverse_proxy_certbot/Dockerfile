FROM osirixfoundation/nginx-certbot:master

ENV SECRET_FILE_PATH=/run/secrets


COPY reverseproxy.conf /etc/nginx/conf.d/reverseproxy.conf
COPY script.sh /docker-entrypoint.d/40-script.sh

