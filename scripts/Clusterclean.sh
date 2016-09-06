#!/bin/bash   
#Author: Peter Swanson
#Cleans a directory of a Clusterbomb created application

echo -n "Removing application... " 

for d in */
do
  rm -rf $d
done

VARLIST=$(find ./ -maxdepth 1 -type f -not -iname "*.sh" | cut -f2 -d"/")

for VAR in $VARLIST
do
	rm -f $VAR
done

cd /etc/
cd init
rm gunicorn.conf

echo Done!