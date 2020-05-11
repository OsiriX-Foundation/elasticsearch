FROM nginx:stable

ENV SECRET_FILE_PATH=/run/secrets

RUN apt-get update &&  apt-get install -y inotify-tools certbot openssl
COPY certbot.sh /opt/certbot.sh
RUN chmod +x /opt/certbot.sh 
ENV LETS_ENCRYPT_EMAIL=spalte@naturalimage.ch

COPY reverseproxy.conf /etc/nginx/conf.d/reverseproxy.conf
COPY script.sh /etc/nginx/conf.d/script.sh

ENTRYPOINT /etc/nginx/conf.d/script.sh
