#!/bin/bash
#Script que verifica a quantidade de dias para o certificado SSL expirar

#endereco do certificado a ser verificado
name="www.testecert.com"
shift

#Pega data atual
now_epoch=$( date +%s )

#calcula a quantidade de dias restante para o certificado expirar
while read _ _ _ _ ip;
do
   expiry_date=$( echo | openssl s_client -showcerts -servername $name -connect $name:443 2>/dev/null | openssl x509 -inform pem -noout -enddate | cut -d "=" -f 2 )
   expiry_epoch=$( date -d "$expiry_date" +%s )
   expiry_days="$(( ($expiry_epoch - $now_epoch) / (3600 * 24) ))"
done < <(dig +noall +answer $name)
echo "$expiry_days"
