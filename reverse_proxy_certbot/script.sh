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

/etc/nginx/conf.d/nginx_certbot_script.sh
