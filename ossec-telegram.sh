#!/bin/sh
# Author: Yevgeniy Goncharov aka xck, http://sys-adm.in
# Send alert to Telegram fromm OSSEC

# Sys env / paths / etc
# -------------------------------------------------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

# Telegram settings
TOKEN="<TOKEN>"
CHAT_ID="<ID>"


ACTION=$1
USER=$2
IP=$3
ALERTID=$4
RULEID=$5

LOCAL=`dirname $0`;
cd $LOCAL
cd ../
PWD=`pwd`


# Logging the call
echo "`date` $0 $1 $2 $3 $4 $5 $6 $7 $8" >> ${PWD}/../logs/active-responses.log


# Getting alert time
ALERTTIME=`echo "$ALERTID" | cut -d  "." -f 1`

# Getting end of alert
ALERTLAST=`echo "$ALERTID" | cut -d  "." -f 2`

# Getting full alert
ALERT=`grep -A 5 "$ALERTTIME" ${PWD}/../logs/alerts/alerts.log | grep -v ".$ALERTLAST: " -A 5`

curl -s \
-X POST \
https://api.telegram.org/bot$TOKEN/sendMessage \
-d text="$ALERT" \
-d chat_id=$CHAT_ID
