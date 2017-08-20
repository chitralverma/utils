#!/bin/bash

#  Author: Chitral Verma
#  Date: 2017-08-20 15:45:28

#  If you're using my code you're welcome to connect with me
#  and optionally send me feedback to help steer this or other code I publish

#  https://www.linkedin.com/in/chitralverma
#  https://stackoverflow.com/story/chitralverma
#  https://github.com/chitralverma


USER=admin
PASSWORD=hadoop
AMBARI_HOST=172.17.0.2
 
#detect name of cluster

CLUSTER=$(curl -s -u $USER:$PASSWORD -i -H 'X-Requested-By: ambari' http://$AMBARI_HOST:8080/api/v1/clusters | sed -n 's/.*"cluster_name" : "\([^\"]*\)".*/\1/p')

echo -e "Detected name of the cluster as: ${CLUSTER}\n"
printf "Proceding to stop all services! "

STOPCOMMAND="curl -s -u $USER:$PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{\"RequestInfo\":{\"context\":\"_PARSE_.STOP.ALL_SERVICES\",\"operation_level\":{\"level\":\"CLUSTER\",\"cluster_name\":\"${CLUSTER}\"}},\"Body\":{\"ServiceInfo\":{\"state\":\"INSTALLED\"}}}' http://$AMBARI_HOST:8080/api/v1/clusters/$CLUSTER/services"

#Spinning Progress Bar
spinner()
{
    local pid=$!
    local delay=0.20
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

result=$(eval $STOPCOMMAND)

sleep 2m &
spinner

echo $result
