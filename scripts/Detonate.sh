#!/bin/bash   
#Author: Peter Swanson
#Adds Gunicorn and Nginx to an application

#Command Line Arguments:
NONGINX=0
NOGUNICORN=0
DEBUG=0
APPNAME="Unknown"
PWDIR="Unknown"

#Colors:
RED='\033[0;91m'
GREEN='\033[0;92m'
YL='\033[0;93m' 
BLUE='\033[0;34m'
LBLU='\033[0;96m'
NC='\033[0m'

disable_debug_sudo ()
{
	echo
	echo -e "${LBLU}Turning off debug${NC}"
	sudo sed -i -e 's/DEBUG = True/DEBUG = False/' $PWDIR/$APPNAME/$APPNAME/settings.py
}

disable_debug ()
{
	echo
	echo -e "${LBLU}Turning off debug${NC}"
	sed -i -e 's/DEBUG = True/DEBUG = False/' $PWDIR/$APPNAME/$APPNAME/settings.py
}

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
	rm -f gunicorn.conf
	
	cat <<EOT >> gunicorn.conf
description "Gunicorn application server handling $APPNAME"

start on runlevel [2345]
stop on runlevel [!2345]

respawn
setuid $USER
setgid www-data
chdir $PWDIR/$APPNAME

exec $PWDIR/venv/bin/gunicorn --workers 3 --bind unix:$PWDIR/$APPNAME/$APPNAME.sock $APPNAME.wsgi:application
EOT
} # Writes a basic config file for gunicorn if superuser privilages 

setup_gunicorn_sudo ()
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
	sudo mkdir -p init
	cd init	
	
	sudo rm -f gunicorn.conf
	
	sudo sh -c "cat >> gunicorn.conf" <<-EOF
description "Gunicorn application server handling $APPNAME"

start on runlevel [2345]
stop on runlevel [!2345]

respawn
setuid $USER
setgid www-data
chdir $PWDIR/$APPNAME

exec $PWDIR/venv/bin/gunicorn --workers 3 --bind unix:$PWDIR/$APPNAME/$APPNAME.sock $APPNAME.wsgi:application
EOF
	
} # Writes a basic config file for gunicorn if superuser privilages are available

setup_nginx ()
{
	echo "Installing and configuring Nginx"
	echo -e "${YL}You may be prompted to enter 'y'${NC}"
	sleep 3
	sudo apt-get update
	sudo apt-get install nginx
	
	sudo rm -f /etc/nginx/sites-available/*
	sudo rm -f /etc/nginx/sites-enabled/*
	
	sudo sh -c "cat >> /etc/nginx/sites-available/$APPNAME" <<-EOF
server {
    listen 80;
    server_name localhost;

	location = /favicon.ico {access_log off; log_not_found off; }
    location /static/ {
        root $PWDIR/$APPNAME;
    }
  
    location / {
        include proxy_params;
        proxy_pass http://unix:$PWDIR/$APPNAME/$APPNAME.sock;
    }
}
EOF

	cd /etc/nginx/sites-enabled
	sudo ln -s ../sites-available/$APPNAME
	
	cd $PWDIR/$APPNAME
	python manage.py collectstatic --noinput
} # Install and configure Nginx
# Allow custom server names

start_nginx ()
{
	sudo service nginx restart
} #Starts/restarts Nginx

start_gunicorn_wsgi ()
{
	cd $PWDIR/$APPNAME
	gunicorn $APPNAME.wsgi 
} #Starts Gunicorn 

start_gunicorn_service_sudo ()
{
	cd $PWDIR/$APPNAME
	sudo service gunicorn restart
} #Starts Gunicorn service

setup_cygwin ()
{
    echo -e "${GREEN}Detected Cygwin as the operating system!${NC}"
	echo
	echo -e "${YL}Only gunicorn can be installed in Cygwin. Nginx can be downloaded as an${NC}"
	echo -e "${YL}executable that is run on Windows itself. There is a link in${NC}"
	echo -e "${YL}the readme.${NC}" 
	echo
		
	setup_gunicorn_nosudo
	start_gunicorn_wsgi
	
	if [[ "$DEBUG" != '1' ]]; then
		disable_debug
	fi
	
} # Sets up Gunicorn on Windows Cygwin

setup_linux ()
{
    echo -e "${GREEN}Detected $OSTYPE as the operating system!${NC}"
	echo
		
	setup_gunicorn_sudo
	start_gunicorn_service_sudo
	
	if [[ $NONGINX == 1 ]]; then
		echo -e "${YL}Skipping Nginx installation${NC}"
	else
		setup_nginx
		start_nginx
	fi
	
	if [[ "$DEBUG" != '1' ]]; then
		disable_debug_sudo
	fi
	
} # Sets up Gunicorn on Windows Cygwin
      
setup_unknown ()
{
    echo -e "${RED}Unsupported operating system $OSTYPE. If your operating system${NC}"
    echo -e "${RED}is incompatible with Clusterbomb, please email ${NC}"
    echo -e "${RED}pswanson@ucdavis.edu and I'll see if I can add it.${NC}"
    echo
	echo -e "${RED}-Peter${NC}"
} # Runs if the OS is unsupported

invalid_arg ()
{
	echo -e "${RED}Argument $* is invalid! Exiting...${NC}"
	exit 1
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
		elif [[ "$ARGUMENT" == "-d" ]] || [[ "$ARGUMENT" == --debug ]]; then
			DEBUG=1
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
	elif [[ "$OSTYPE" == 'linux-gnu' ]]; then
		setup_linux $1
	else
		setup_unknown
	fi
	
	
} #Main
# ADD:
	#Linux, OSX at least!

main $@

exit 1