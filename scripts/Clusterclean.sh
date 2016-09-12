#!/bin/bash   
#Author: Peter Swanson
#Cleans a directory of a Clusterbomb created application

# Command Line Arguments:
SHRAPNEL=0

#Detected:
VARLIST=$(find ./ -maxdepth 1 -type f -not -iname "*.sh" | cut -f2 -d"/")

#Colors:
RED='\033[0;91m'
GREEN='\033[0;92m'
YL='\033[0;93m' 
BLUE='\033[0;34m'
LBLU='\033[0;96m'
NC='\033[0m'

remove_directories ()
{
	for d in */
	do
		rm -rf $d
	done
}

remove_files ()
{
	for VAR in $VARLIST
	do
		rm -f $VAR
	done
}

remove_shrapnel ()
{
	if [[ $OSTYPE == 'cygwin' ]]; then
		rm -f /etc/init/gunicorn.conf
	else
		sudo rm -f gunicorn.conf
		sudo rm -f /etc/nginx/sites-available/*
		sudo rm -f /etc/nginx/sites-enabled/*	
	fi
}

invalid_arg ()
{
	echo -e "${RED}Argument $* is invalid! Exiting...${NC}"
	exit 0
} # Exits on invalid command line argument

cla_parser ()
{
	for ARGUMENT in "$@"
	do
		
		if [[ "$ARGUMENT" == -[^-]* ]]; then
			LENGTH=${#ARGUMENT}
			START=1
						
			while [ $START -lt $LENGTH ]
			do
				ARG="-${ARGUMENT:$START:1}"
				CLA+=("$ARG")	
				START=$[START+1]
			done
		
		elif [[ "$ARGUMENT" == --* ]]; then
			CLA+=("$ARGUMENT")
		
		else
			invalid_arg $ARGUMENT
		fi		
		
	done
	
} # Parses command line arguments and checks argument formatting

get_cla ()
{
	cla_parser $@
	
	for ARGUMENT in "${CLA[@]}"
	do
	
		if [[ "$ARGUMENT" == "-s" ]] || [[ "$ARGUMENT" == --shrapnel ]]; then
			SHRAPNEL=1
		else
			invalid_arg $ARGUMENT
		fi
		
	done
} # Reads accepted command line arguments

main ()
{
	echo "Removing application... " 
	
	get_cla $@
	remove_directories
	remove_files
	
	if [[ $SHRAPNEL == 1 ]]; then
		remove_shrapnel
	fi
	
	echo Done!
}

main $@