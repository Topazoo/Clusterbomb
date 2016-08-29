#!/bin/bash   
#Author: Peter Swanson
#Adds Gunicorn and Nginx to an application

#Command Line Arguments:
NONGINX=0
NOGUNICORN=0

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

main ()
{
	echo
	
	get_cla $@

	if [[ "$OSTYPE" == 'cygwin' ]]; then
		setup_cygwin $1
	else
		setup_unknown
	fi
} #Main
# ADD:
	#Ubuntu, Linux, OSX at least!

main $@

exit 1