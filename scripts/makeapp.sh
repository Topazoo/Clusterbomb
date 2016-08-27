#!/bin/bash   
#Author: Peter Swanson
#Creates a Django Application based on user entered parameters


read -r -p "Please enter a name for the application: " APPLNAME
echo 
echo 'Creating a Python 2.7 virtual environment called "venv"' 
echo 
virtualenv -p /usr/bin/python2.7 venv
echo 'Successfully created virtual environment' 
source venv/bin/activate

echo Installing pip packeges
pip install django~=1.9.0

echo
echo Creating Django Application $APPLNAME
django-admin startproject $APPLNAME 

echo Created project $APPLNAME!
echo 

echo Setting up application....
cd $APPLNAME/$APPLNAME
echo "STATIC_ROOT = os.path.join(BASE_DIR, 'static')" >> settings.py
cd ..
python manage.py migrate
echo

echo Starting application...
python manage.py runserver

