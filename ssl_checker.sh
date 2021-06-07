#!/bin/bash
#Give Domain and port as argument along with the script
domain=$1
port=$2
expiry_date="$(echo | openssl s_client -servername $domain -connect $domain:$port 2>/dev/null | openssl x509 -noout -dates |grep -i after |cut -d "=" -f2)"
expiry_epoch="$(date -d "$expiry_date" +"%s")"
date_epoch="$(date +"%s")"
diff=$(( $expiry_epoch-$date_epoch ))
expire_days="$(eval "echo $(date -ud "@$diff" +'$((%s/3600/24))')")"
if [[ "$expire_days" -le "30" ]]; then
	echo "Critical: SSL certificate will expire soon  within $expire_days days"
else
	echo "Certificate will expire in $expire_days days"
fi	
