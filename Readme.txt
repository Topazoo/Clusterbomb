Clusterbomb for Django!

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
- Clusterbomb.sh	Starts a django instance with a base or preselected template
- Clusterclean.sh	Cleans an instance and venv (mostly for development)
- Detonate.sh		Gets your django instance AWS ready

Supported Operating Systems:

> Cygwin:
	- All (Nginx not currently supported on Cygwin alone, download the exe at http://nginx.org/en/download.html)
