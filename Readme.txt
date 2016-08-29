Clusterbomb for Django!

Requirements:

	- A version of Python 2.0 - 3.5 installed on the OS running the instance
	  Python 2.7 is required for default installation
	- Python pip installed on the OS running the instance

Clusterbomb:

	- Creates a virtual environment and installs packages
	- Creates a Django application
	- Configures it for the first time
	- Migrates the database
	- Creates base project files
	- Creates base project templates
	- Configures URLs
	- Installs and configures Gunicorn
	- Installs and configures Nginx 

Files Included:

	- Clusterbomb.sh	Starts a Django application with a base template
	- Clusterclean.sh	Cleans an instance and venv (mostly for development)
	- Detonate.sh		Gets your Django instance Amazon Web Server ready

Commands:

	> Clusterbomb.sh:
	
		- ./Clusterbomb.sh			
		
		Sets up a Python 2.7 virtual enironment, a base 
		Django 1.9 application with an SQLite database, 
		runs Detonate.sh, and then runs the server.
								
		- ./Clusterbomb.sh -c		
		
		Allows the user to choose the virtual environment version,
		Django version, creates a base application with an SQlite 
		or Postgres database, and runs Detonate.sh with user specified 
		arguments.
								
	> Detonate.sh:
	
		- ./Detonate.sh		
		
		Installs and configures gunicorn for the application.
		Installs Nginx on compatible OS' and configures it for the application.
								
		- ./Detonate.sh	-nonginx	
		
		Installs and configures only gunicorn for the application.

		- ./Detonate.sh	-nongunicorn	
		
		Installs and configures only Nginx on compatible OS' and configures 
		it for the application	
								


Supported Operating Systems:

> Cygwin:
	- All (Nginx not currently supported on Cygwin alone, download
      the exe at http://nginx.org/en/download.html).
	  
	  
