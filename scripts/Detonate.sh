#!/bin/bash   
#Author: Peter Swanson
#Adds Gunicorn and Nginx to an application

#Command Line Options:
NONGINX=0
NOGUNICORN=0

setup_cygwin ()
{
    echo Detected Cygwin as the operating system!
	echo
	
	if [[ $NOGUNICORN == 0 ]]; then
		echo Since you are using Windows only Gunicorn
		echo can be installed in Cygwin. Nginx can be downloaded as an
		echo executable that is run on Windows itself. There is a link in
		echo the readme. 
		echo
	else
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

read_cla ()
{
	case "-nonginx" in 
	   "$@") NONGINX=1;;
	esac

	case "-nogunicorn" in 
	   "$@") NOGUNICORN=1;;
	esac		
} # Reads command line arguments  

main ()
{
	echo
	if [[ "$OSTYPE" == 'cygwin' ]]; then
		read_cla $@
		setup_cygwin $1
	else
		setup_unknown
	fi
} #Main
# ADD:
	#Ubuntu, Linux, OSX at least!

main $1

exit 1