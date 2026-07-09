USER_DOC.md — User documentation This file must explain, in clear and simple
terms, how an end user or administrator can:
◦Understand what services are provided by the stack.
◦Start and stop the project.
◦Access the website and the administration panel.
◦Locate and manage credentials.
◦Check that the services are running correctly.

USER DOCUMENTATION

This repo consists of 3 Docker containers :
- Nginx webserver
- Mariadb server
- Wordpress + php-fpm install

Once built with make up, they will launch automatically and host a clean wordpress install accessible through localhost or [username].42.fr (redirecting to localhost through a modification of the hosts file)

Makefile commands :

make all : builds and launch the docker images
make down : shuts down all the containers
make re : shuts down and rebuild, relaunch
make clean : shuts down and remove all containers and created volumes
make fclean : same as clean but deletes the persistent files of your wordpress + db

Accessing the website :
Opening a browser to localhost or [username].42.fr in https

Accessing the admin panel :
localhost/wp-admin/ or [username].42.fr/wp-admin/

Credentials :
All the credentials are managed through docker secrets and need to be present in 2 texts files located in the secrets folder

sql_credentials.txt must contain :
SQL_ROOT_PASSWORD=xxx
SQL_USER=xxx
SQL_PASSWORD=xxx
SQL_ADMIN=xxx
SQL_ADMINPASSWORD=xxx

wp_credentials.txt must contain :
WP_ADMIN_USER=xxx
WP_ADMIN_PASSWORD=xxx
WP_ADMIN_EMAIL=xxx

Checking if services are ok :
If the initialisation went right (no container exited or restarted), a simple
docker container ls
should list the three containers and their status
