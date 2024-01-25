#!/bin/bash

# We need the redis-server running in the background
redis-server --daemonize yes
# Start biomedisa processes
python3 /home/biomedisa/manage.py migrate
# Following super user creation would most likely have no
# effect in this case because there is no TTY attached
# to the container process.
python3 /home/biomedisa/manage.py createsuperuser
cd /home/biomedisa
./start_workers.sh
# TODO: Make sure that apache server is needed
# Restart apache web server
service apache2 restart
# Run DJANGO server for the biomedisa app
# Reason to target all interfaces(0.0.0.0) instead of the localhost or
# loopback address is described in this post:
# https://stackoverflow.com/questions/49476217/docker-cant-access-django-server
python3 /home/biomedisa/manage.py runserver 0.0.0.0:9999
