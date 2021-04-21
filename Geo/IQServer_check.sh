#!/bin/bash 

. /opt/sybase/sybase_iq/IQ.sh

TimeStamp() 
{ 
date +'%Y/%m/%d-%H:%M:%S|' 
} 

DBPATH=/opt/sybase/servers/
ServerList=`ls /opt/sybase/servers/ |grep IQ|xargs`
LOGIFLE=/opt/sybase/scripts/log/IQServer_Check-`date +'%Y%m%d'`.log

for i in `cat $SYBASE/interfaces|grep IQ| xargs`
do
	dbping -q -c dsn=${i} > /dev/null 2>&1
	if [ $? == 0 ];then
		COORD=$(dbisql -c dsn=${i} "select server_name from sp_iqmpxinfo() where role='coordinator'"|sed -n 3p)
		break
	fi
done

ErrorMsg()
{
Message=( "out of synchronization" "not included" "file does not exist" )
for j in "${Message[@]}"
	do
	grep "$j" $logfile > /dev/null
	if [ "$?" == 0 ]; then 
		text=$j
		break
	fi
	done
}

for i in $ServerList
	do
	dbping -q -c dsn=$i > /dev/null 2>&1
	if [ "$?" != 0 ];then
		echo -e "\e[31m$(TimeStamp) $i is not running\e[0m" >> $LOGIFLE
		#ServerName=`ls $DBPATH | grep TIQ | xargs`
		logfile=$DBPATH/$i/log/$i.0001.stderr
		sh $DBPATH/$i/start_$i 2>&1 > $logfile
		dbping -q -c dsn=$i > /dev/null 2>&1
		if [ "$?" == 0 ];then
			echo -e "\e[32m$(TimeStamp) $i started successfully\e[0m" >> $LOGIFLE
		else
			ErrorMsg
			case $text in
				"out of synchronization")
					echo -e "\e[31m$(TimeStamp) $i is Out of Synchronization\e[0m" >> $LOGIFLE
					echo -e "\e[31m$(TimeStamp) Resyncing $i Mutliplex Server\e[0m" >> $LOGIFLE
					/opt/sybase/scripts/resync.sh --from $COORD --to $i >> $logfile
					if [ "$?" == 0 ];then echo -e "\e[32m$(TimeStamp) $i started successfully\e[0m" >> $LOGIFLE; fi
					;;
				"not included")
					echo -e "\e[31m$(TimeStamp) $i is not included \e[0m" >> $LOGIFLE
					echo -e "\e[31m$(TimeStamp) Including Server $i \e[0m" >> $LOGIFLE
					dbisql -c dsn=$COORD "alter multiplex server $i status included";
					echo -e "\e[31m$(TimeStamp) Resyncing $i Mutliplex Server\e[0m" >> $LOGIFLE
					/opt/sybase/scripts/resync.sh --from $COORD --to $i >> $logfile
					if [ "$?" == 0 ];then echo -e "\e[32m$(TimeStamp) $i started successfully\e[0m" >> $LOGIFLE; fi
					;;
				"file does not exist")
					echo -e "\e[31m$(TimeStamp) Please check DB file for $i\e[0m" >> $LOGIFLE
					;;
				*)
					echo -e "\e[31m$(TimeStamp) Please check the iqmsg log for $i\e[0m" >> $LOGIFLE
			esac
		fi
	fi		
done
