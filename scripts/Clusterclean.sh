#!/bin/bash   
#Author: Peter Swanson
#Cleans a directory of a Clusterbomb created application

echo -n "Removing application... " 

for d in */
do
  rm -r $d
done

echo Done!