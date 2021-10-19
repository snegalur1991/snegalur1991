#!/bin/sh
df -h | grep '/' | grep -vE 'tmpfs|/dev/sda1|/iqstage01' |awk '{print $4 " " $5}' | while read output;
do
#  echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [[ $usep -ge 95 ]]
  then
  echo $usep
  echo $partition
host=`hostname`
tstmp=`date '+%Y-%m-%d %H:%M:%S'`
/usr/lib/sendmail -t <<- EOF
From: "${host} ALERTS" <dbasupport@sinch.com>
To: DI.DBS.DBA.Support@sinch.com 
Subject: Alert: File System usage reached to $usep%
Running out of space on  File System: "$partition ($usep%)" on ${host} as on ${tstmp}
EOF
  fi
done
