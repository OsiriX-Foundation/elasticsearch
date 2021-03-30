FROM nginx:1.19.8

ENV SECRET_FILE_PATH=/run/secrets

COPY reverseproxy.conf /etc/nginx/conf.d/reverseproxy.conf
COPY script.sh /etc/nginx/conf.d/script.sh

ENTRYPOINT /etc/nginx/conf.d/script.sh
