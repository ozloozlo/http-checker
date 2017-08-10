#!/bin/bash

##########
# CONFIG #
##########

LOG_DIR="/var/log"
LOG_FILE="$(date +'%Y-%m-%d')-http-checker.log"
SENDER_EMAIL="sender@email.com"
TIMEOUT=600

##############
# THE SCRIPT #
##############
# create log file

if [ ! -f "$LOG_DIR/$LOG_FILE" ]; then
#    echo "create file: "$LOG_FILE 
    touch $LOG_DIR/$LOG_FILE
fi
#enter parameters
while [ -n "$1" ]
do
  case "$1" in
    -h) HOST="$2"
      echo "Found the -h option, with parameter $HOST" >> $LOG_DIR/$LOG_FILE
      shift 2;;
    -m) ADMINS_EMAIL="$2"
      echo "Found the -m option, with parameter $ADMINS_EMAIL" >> $LOG_DIR/$LOG_FILE
      shift 2;;
    *) echo "$1 is not a key" >&2
      exit 1;;
  esac
done
# check parameters
#echo $HOST
#echo $ADMINS_EMAIL
if [[ "$HOST" = "0" ]]; then
  echo "I couldn\'t find \"-h\" key. Try run the script again."
  exit 1
elif [[ "$ADMINS_EMAIL" = "0" ]]; then
  echo "I couldn\'t find \"-m\" key. Try run the script again."
  exit 1
else
  echo "Script started"
  while true; do  
    TIMESTAMP=`date '+%h %d %k:%M:%S'`
    CURL_REQUEST=`curl -Is $HOST 2>>$LOG_DIR/$LOG_FILE | head -n 1 | awk -F" " '{print $2}'`
    #CURL_REQUEST=`curl -Is $HOST  | head -n 1 | awk -F" " '{print $2}'`
    #echo `curl -Is $HOST 2>>$LOG_DIR/$LOG_FILE | head -n 1 `
    #echo `curl -Is $HOST | head -n 1 `
    echo $TIMESTAMP "Site " $HOST " returned status " $CURL_REQUEST >> $LOG_DIR/$LOG_FILE
    if [[ "$CURL_REQUEST" -ge 400 ]]; then
# sending e-mail
      echo $TIMESTAMP "Sending notification to Admin" >> $LOG_DIR/$LOG_FILE
      echo "From: HTTP-CHECKER <$SENDER_EMAIL>" > /tmp/mail_template
      echo "To: Admin <$ADMINS_EMAIL> " >> /tmp/mail_template
      echo "Subject: Problem with $HOST" >> /tmp/mail_template
      echo $TIMESTAMP "Site $HOST returned status $CURL_REQUEST" >> /tmp/mail_template
      cat /tmp/mail_template |   sendmail $ADMINS_EMAIL
    fi
    sleep $TIMEOUT
  done
fi






