#!/bin/bash

missing_env_var_secret=false


#Verify environment variables
if [[ -z $KHEOPS_ROOT_SCHEME ]]; then
  echo "Missing KHEOPS_ROOT_SCHEME environment variable"
  missing_env_var_secret=true
else
   echo -e "environment variable KHEOPS_ROOT_SCHEME \e[92mOK\e[0m"
fi
if [[ -z $KHEOPS_ROOT_HOST ]]; then
  echo "Missing KHEOPS_ROOT_HOST environment variable"
  missing_env_var_secret=true
else
   echo -e "environment variable KHEOPS_ROOT_HOST \e[92mOK\e[0m"
fi

if [[ -z $LETS_ENCRYPT_EMAIL ]]; then
  echo "Missing LETS_ENCRYPT_EMAIL environment variable"
  missing_env_var_secret=true
else
   echo -e "environment variable LETS_ENCRYPT_EMAIL \e[92mOK\e[0m"
fi


#if missing env var or secret => exit
if [[ $missing_env_var_secret = true ]]; then
  exit 1
else
   echo -e "all nginx secrets and all env var \e[92mOK\e[0m"
fi


export roothost="$(awk -F/ '{sub("^[^@]+@","",$3); print $3}' <<<$KHEOPS_ROOT_URL)"

#get env var
chmod a+w /etc/nginx/conf.d/reverseproxy.conf
sed -i "s|\${root_url}|$KHEOPS_ROOT_SCHEME://$KHEOPS_ROOT_HOST|" /etc/nginx/conf.d/reverseproxy.conf

sed -i "s|\${server_name}|$KHEOPS_ROOT_HOST|" /etc/nginx/conf.d/reverseproxy.conf

echo "Ending setup NGINX secrets and env var"


### Let's Encrypt
# based on https://ilhicas.com/2019/03/02/Nginx-Letsencrypt-Docker.html
# Create a self signed default certificate, so Ngix can start before we have
# any real certificates.

#Ensure we have folders available

if [[ ! -f /usr/share/nginx/certificates/fullchain.pem ]];then
    mkdir -p /usr/share/nginx/certificates
fi

### If we already have certbot generated certificates, copy them over
if [[ -f "${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/$roothost/privkey.pem" ]]; then
    cp "${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/$roothost/privkey.pem" /usr/share/nginx/certificates/privkey.pem
    cp "${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/$roothost/fullchain.pem" /usr/share/nginx/certificates/fullchain.pem
    cp "${LETSENCRYPT_DIR:-/etc/letsencrypt}/live/$roothost/chain.pem" /usr/share/nginx/certificates/chain.pem
else
    openssl genrsa -out /usr/share/nginx/certificates/privkey.pem 4096
    openssl req -new -key /usr/share/nginx/certificates/privkey.pem -out /usr/share/nginx/certificates/cert.csr -nodes -subj \
    "/C=PT/ST=World/L=World/O=$roothost/OU=kheops lda/CN=${roothost}"
    openssl x509 -req -days 365 -in /usr/share/nginx/certificates/cert.csr -signkey /usr/share/nginx/certificates/privkey.pem -out /usr/share/nginx/certificates/fullchain.pem
    cp /usr/share/nginx/certificates/fullchain.pem /usr/share/nginx/certificates/chain.pem
fi

### Send certbot Emission/Renewal to background
$(while :; do /opt/certbot.sh; sleep "12h"; done;) &

### Check for changes in the certificate (i.e renewals or first start) and send this process to background
$(while inotifywait -e close_write /usr/share/nginx/certificates; do nginx -s reload; done) &


#######################################################################################

nginx-debug -g 'daemon off;'
