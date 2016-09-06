#!/bin/bash   
#Author: Peter Swanson
#Adds Gunicorn and Nginx to an application

#Command Line Arguments:
NONGINX=0
NOGUNICORN=0
APPNAME="Unknown"
PWDIR="Unknown"

#Colors:
RED='\033[0;91m'
GREEN='\033[0;92m'
YL='\033[0;93m' 
BLUE='\033[0;34m'
LBLU='\033[0;96m'
NC='\033[0m'

setup_gunicorn_nosudo ()
{
	pip install gunicorn
	echo
	echo Setting up Gunicorn...
	echo
	echo -e "${LBLU}Launching server...${NC}"
	
	cd $PWDIR/$APPNAME/$APPNAME
	
	if [[ $(grep -c "from django.contrib.staticfiles.urls" urls.py) -eq 0 ]]; then
		sed -i '1s/^/from django.contrib.staticfiles.urls import staticfiles_urlpatterns\n/' urls.py
		echo "urlpatterns += staticfiles_urlpatterns()" >> urls.py
	fi
	
	cd /etc/
	mkdir -p init
	cd init	
	
	cat <<EOT >> gunicorn.conf
description "Gunicorn application server handling $APPNAME"

start on runlevel [2345]
stop on runlevel [!2345]

respawn
setuid $USER
setgid www-data
chdir /home/$USER/$APPNAME

exec venv/bin/gunicorn --workers 3 --bind unix:/home/$USER/$APPNAME/$APPNAME.sock $APPNAME.wsgi:application

EOT
} # Writes a basic config file for gunicorn

start_gunicorn ()
{
	cd $PWDIR/$APPNAME
	gunicorn $APPNAME.wsgi 
}

setup_cygwin ()
{
    echo -e "${GREEN}Detected Cygwin as the operating system!${NC}"
	echo
	echo -e "${YL}Only gunicorn${NC}"
	echo -e "${YL}can be installed in Cygwin. Nginx can be downloaded as an${NC}"
	echo -e "${YL}executable that is run on Windows itself. There is a link in${NC}"
	echo -e "${YL}the readme.${NC}" 
	echo
		
	if [[ $NOGUNICORN == 1 ]]; then
		echo -e "${YL}Since you\'ve disabled gunicorn setup, Detonate${NC}"
		echo -e "${YL}will now exit...${NC}"
		exit 1
	else
		setup_gunicorn_nosudo
		start_gunicorn
	fi
	
} # Sets up Gunicorn on Windows Cygwin
      
setup_unknown ()
{
    echo -e "${RED}Unsupported operating system. If your operating system${NC}"
    echo -e "${RED}is incompatible with Clusterbomb, please email ${NC}"
    echo -e "${RED}pswanson@ucdavis.edu and I\'ll see if I can add it.${NC}"
    echo
	echo "${RED}-Peter${NC}"
} # Runs if the OS is unsupported

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
	
		if [[ "$ARGUMENT" == "-g" ]] || [[ "$ARGUMENT" == --nonginx ]]; then
			NONGINX=1
		elif [[ "$ARGUMENT" == "-n" ]] || [[ "$ARGUMENT" == --nogunicorn ]]; then
			NOGUNICORN=1
		else
			invalid_arg $ARGUMENT
		fi
		
	done
} # Reads accepted command line arguments

get_name()
{
	APPNAME=$(find * -type d ! -name 'venv' ! -path . ! -print | head -1)
} # Gets the name of the application

main ()
{
	get_name $@
	PWDIR=$(pwd)
	
	echo 
	if [[ ${#APPNAME} == 0 ]]; then
		echo -e "${RED}Couldn't find a Django application! Exiting!${NC}"
		exit 1
	else 
		echo -e "${GREEN}Detected application named $APPNAME${NC}"
	fi
	
	source venv/bin/activate
	
	get_cla $@

	if [[ "$OSTYPE" == 'cygwin' ]]; then
		NONGINX=1
		setup_cygwin $1
	else
		setup_unknown
	fi
	
	
} #Main
# ADD:
	#Ubuntu, Linux, OSX at least!

main $@

exit 1