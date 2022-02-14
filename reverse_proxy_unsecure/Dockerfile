FROM nginx:1.21.6

ENV SECRET_FILE_PATH=/run/secrets

COPY reverseproxy.conf /etc/nginx/conf.d/reverseproxy.conf
COPY script.sh /etc/nginx/conf.d/script.sh

RUN rm /etc/nginx/conf.d/default.conf

ENTRYPOINT /etc/nginx/conf.d/script.sh
