#!/bin/bash
# Owner : PIYUSH RAKHUNDE
# Shell script to edit the jmeter.properties of a jmeter-master slave file to add the remote hosts where the jmeter-slave is running

# PLEASE ENSURE TO CONFIRM THE IP ADDRESS OF THE MARATHON MASTER BEFORE BUILDING the DOCKER FILE WITH THIS SHELL SCRIPT

echo "Getting Apps Running on the Marathon......"

MARATHON_SERVER_IP=${MARATHON_SERVER}

MARATHON_SERVER_APPS="http://"$MARATHON_SERVER_IP":8080/v2/apps/jmeter-slave/tasks"
CURL_OUTPUT="$(curl "$MARATHON_SERVER_APPS")"

VALUE="$(echo $CURL_OUTPUT | python -c 'import sys;import json;
items = json.load(sys.stdin)["tasks"]
for item in items:
 	host = item.get("host")
	print host
')"

PORTS="$(echo $CURL_OUTPUT | python -c 'import sys;import json;
items = json.load(sys.stdin)["tasks"]
for item in items:
        ports = item.get("ports")
        port = ports[0]
        print port
')"

# Variable contains all the host names where jmeter slave is running
# echo Hostnames: $VALUE
# echo Ports: $PORTS

# below creates the final string to be append inside the jmeter properties. Currently it only considers the default port 31837

COUNT="$(echo $VALUE | wc -w)"
# echo $COUNT  // Total servers on which jmeter slave is running
a=1
hosts=" "
FINAL=""
while [ $a -le $COUNT ]
do
   hosts="$(echo $VALUE | cut -d' ' -f $a)"
   iport="$(echo $PORTS | cut -d' ' -f $a)"
   FINAL=$FINAL$hosts":"$iport
   a=`expr $a + 1`
   if [ $a -le $COUNT ]; then
       FINAL=$FINAL","
   fi   
done
echo $FINAL
echo "Generating the JMETER.PROPERTIES file ..."
while read a ; do echo ${a//"REPLACE_REMOTE_HOSTS_JMETERSLAVE"/$FINAL} ; done < ${JMETER_PATH}/jmeter.properties > ${JMETER_PATH}/jmeter.properties.t ; mv ${JMETER_PATH}/jmeter.properties{.t,}
echo "Done Editing."
