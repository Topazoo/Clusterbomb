#!/bin/bash   
#Author: Peter Swanson
#Adds Gunicorn and Nginx to an application

#Command Line Arguments:
NONGINX=0
NOGUNICORN=0

get_packages ()
{
	echo 
	echo Installing server packages...
	echo
	
	source venv/bin/activate
	
	if [[ $NOGUNICORN == 0 ]]; then
		pip install gunicorn
	fi
	
	pip list
} # Gets server packages 

setup_cygwin ()
{
    echo Detected Cygwin as the operating system!
	echo
	echo Since you are using Windows only Gunicorn
	echo can be installed in Cygwin. Nginx can be downloaded as an
	echo executable that is run on Windows itself. There is a link in
	echo the readme. 
	echo
		
	if [[ $NOGUNICORN == 1 ]]; then
		echo Since you\'ve disabled Gunicorn setup, Detonate
		echo will now exit...
		exit 1
	fi
	
} # Sets up Gunicorn on Windows Cygwin
      
setup_unknown ()
{
    echo Unsupported operating system. If your operating system
    echo "is incompatible with Clusterbomb, please email "
    echo "pswanson@ucdavis.edu and I'll see if I can add it. "
    echo
	echo "-Peter"
} # Runs if the OS is unsupported

get_cla ()
{
	for ARGUMENT in "$@"
	do
		case "$ARGUMENT" in
		
			-g*|--nonginx*) NONGINX=1
			;;
			
			-n*|--nogunicorn*) NOGUNICORN=1
			;;
			
			*) echo "$ARGUMENT is not a valid argument"
			   echo "read the documentation for more info."
			;;
			
		esac
	done
	
} # Reads command line arguments

invalid_arg ()
{
	echo Argument $* is invalid! Exiting...
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
	
		if [[ "$ARGUMENT" == "-g" ]] || [[ "$ARGUMENT" == --nonginx ]]; then
			NONGINX=1
		elif [[ "$ARGUMENT" == "-n" ]] || [[ "$ARGUMENT" == --nogunicorn ]]; then
			NOGUNICORN=1
		else
			invalid_arg $ARGUMENT
		fi
		
	done
} # Reads accepted command line arguments

main ()
{
	echo
	
	get_cla $@

	if [[ "$OSTYPE" == 'cygwin' ]]; then
		NONGINX=1
		setup_cygwin $1
	else
		setup_unknown
	fi
	
	get_packages
} #Main
# ADD:
	#Ubuntu, Linux, OSX at least!

main $@

exit 1