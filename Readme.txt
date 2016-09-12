Clusterbomb for Django!


Requirements:

	- A version of Python 2.0 - 3.5 installed on the OS running the script
	- Python pip installed on the OS running the script

	
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
	- Clusterclean.sh	Removes a Clusterbomb project
	- Detonate.sh		Gets your Django application Amazon Web Server ready

	
Commands:

	- Clusterbomb.sh:
	  Arguments: Clusterbomb.sh -c -d |or| Clusterbomb.sh -a
	
		> ./Clusterbomb.sh			
		
		Auto-detects the user's Python version, and 
		creates a virtual enironment in that version,
		a base Django 1.9 application with an SQLite 
		database, runs Detonate.sh, and then runs the 
		server.
								
		> ./Clusterbomb.sh -c [--custom]
		
		Allows the user to choose the virtual environment version,
		Django version, creates a base application with an SQlite 
		or Postgres database, and runs Detonate.sh with user specified 
		arguments.
		
		> ./Clusterbomb.sh -d [--dud]

		Does not run Detonate.sh at the end of application setup.
		
		> ./Clusterbomb.sh -a [--detargs]
		
		Runs the default Clusterbomb setup but allows arguments for Detonate
	
	- Clusterclean.sh:
	
		> ./Clusterclean.sh
		
		Cleans all non shellscript files, and directories from 
		the current directory in case of mistakes or errors during
		a setup. 
		
		> ./Clusterclean.sh -s [--shrapnel]
		
		Cleans all non shellscript files, and directories from 
		the current directory in case of mistakes or errors during
		a setup. Removes gunicorn and Nginx config files.
		
	
	- Detonate.sh:
	  Arguments: Detonate.sh -n -d
	
		> ./Detonate.sh		
		
		Installs and configures gunicorn for the application.
		Installs Nginx on compatible OS' and configures it for the application.
								
		> ./Detonate.sh	-g [--noginx]	
		
		Installs and configures only gunicorn for the application.
		
		> ./Detonate.sh -d [--debug]
		
		Keeps the debug variable in settings set to "True"	
								

Known Supported Operating Systems:

> Cygwin:
	- All (Nginx not currently supported on Cygwin alone, download
      the exe at http://nginx.org/en/download.html).
	  
> Ubuntu 14:
	- All
	  
Known Supported Python Versions:

> 2.7
