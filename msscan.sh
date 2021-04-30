#!/bin/bash

rangefile=filename.txt
ports=40
threads=10
mrate=1000
timeout=3
logfile=log.txt
#------------------------------------------------------------------------------------------------
function nmapports {
nmap --top-ports $1 localhost -v -oG - | grep "# Ports scanned" | awk -F'(' '{print $2}' | awk -F')' '{print $1}' | awk -F';' '{print $2}'
}
#------------------------------------------------------------------------------------------------
echo "$(date +"%m-%d-%Y %T") | ------------------------------------------------------------------------------------------------" >> $logfile
echo "$(date +"%m-%d-%Y %T") | New job started" | tee -a $logfile
portsforscan=$(nmapports $ports)
echo "$(date +"%m-%d-%Y %T") | $ports ports per IP to scan: $portsforscan" | tee -a $logfile
for record in $(cat $rangefile)
do
echo Processing $record...
ips=$(host -W$timeout -4 $record | grep 'has address' | awk -F'has address ' '{print $2}' | tr -t '\n' ' ')
if [ -z "$ips" ]
then
    echo "$(date +"%m-%d-%Y %T") | $record - no IP record found " >>$logfile
else
    echo "$(date +"%m-%d-%Y %T") | $record - IPv4 = $ips" >>$logfile
    for ipsl2 in $ips
    do
    curthreads=$(ps aux | grep 'masscan' | grep -v 'grep' | wc -l)
    while [ $curthreads -gt $threads ]
    do
    echo Too many threads running: $curthreads. Current limit: $threads. Sleep for 2 secs.
    sleep 2
    curthreads=$(ps aux | grep 'masscan' | grep -v 'grep' | wc -l)
    done
    nohup bash -c "masscan -p$portsforscan $ipsl2 --rate=$mrate -oG x.result.$record.$ipsl2.txt &" > /dev/null 2>&1
    done
fi
done

echo "$(date +"%m-%d-%Y %T") | Job id done" | tee -a $logfile
