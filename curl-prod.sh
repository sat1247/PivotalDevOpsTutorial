#!/bin/bash
# adding some background load to prod allows for more realistic comparisons
for (( ; ; ))
do
curl --silent --output /dev/null "http://$1/"
#curl --silent --output /dev/null "http://$1/version"
#curl --silent --output /dev/null "http://$1/api/echo?text=This is from a testing script"
curl --silent --output /dev/null "http://$1/api/invoke?url=http://www.dynatrace.com"
done
