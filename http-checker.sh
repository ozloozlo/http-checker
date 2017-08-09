#!/bin/bash

##########
# CONFIG #
##########

USER="root"
LOG_DIR="/var/log"
LOG_FILE="$(date +'%Y-%m-%d')-http-checker.log"
#ADMINS_EMAIL="prososov@gmail.com"
CURL_REQUEST=`curl -I $HOST 2>$LOG_DIR/$LOG_FILE | head -n 1 | awk -F" " '{print $2}'`

##############
# THE SCRIPT #
##############
# create log file

if [ ! -f "$LOG_DIR/$LOG_FILE" ]; then
    echo "create file: "$LOG_FILE 
    touch $LOG_DIR/$LOG_FILE
fi

while [ -n "$1" ]
do
case "$1" in
-h) HOST="$2"
echo "Found the -h option, with parameter value $HOST"
shift ;;
-m) ADMINS_EMAIL="$2"
echo "Found the -m option, with parameter value $ADMINS_EMAIL"
shift ;;
*) echo "$1 is not an option";;
done






# sending e-mail
echo "From: HTTP-CHECKER <sender@email.com>" > /tmp/mail_template
echo "To: Admin <$ADMINS_EMAIL> " >> /tmp/mail_template
echo "Subject: Problem with  >> /tmp/mail_template
echo " " >> /tmp/mail_template
cat /tmp/mail_template |   sendmail $ADMINS_EMAIL

