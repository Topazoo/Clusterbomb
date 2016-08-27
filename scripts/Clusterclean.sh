#!/bin/bash   
#Author: Peter Swanson
#Cleans a directory of a Clusterbomb created application

echo -n "Enter the name of the application to remove: " 
read APPLNAME

rm -r venv $APPLNAME *.tmp

echo Done!