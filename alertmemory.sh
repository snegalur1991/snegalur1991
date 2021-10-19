#!/bin/bash 
#######################################################################################
#Script Name    :alertmemory.sh
#Description    :send alert mail when server memory is running low
#Args           :       
#Author         :Vinay S
#Email          :vinay.s01@sap.com
#######################################################################################
## declare mail variables
##email subject 
subject="Us2iqdevdb001.lab Server Memory Status Alert"
## sending mail to
to="DL_SYB-DBASUPPORT@exchange.sap.corp"

## get total free memory size in megabytes(MB) 
free=$(free -mt | grep Mem | awk '{print $4}')
Memory=$(free -m | awk 'NR==2{printf "%.2f%%\n", $3*100/$2 }')

## check if free memory is greater to 96%
if [[ "$Memory" > 96 ]]; then
        ## get top processes consuming system memory 
       PL=$(ps aux  | awk '{print $6/1024 " MB\t\t" $11}'  | sort -n | tail) 

        ## send email if system memory is running low
        echo -e "Warning, server memory is running low!\n\nPhysical Memory has exceeded threshold: (96%) currently ($Memory) and Free memory: $free MB\n\nTop processes consuming system memory\n$PL" | mail -s "$subject"  "$to" 
fi

exit 0
