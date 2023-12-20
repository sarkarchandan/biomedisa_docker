#!/bin/bash

python3 /home/biomedisa/manage.py migrate
python3 /home/biomedisa/manage.py createsuperuser
/home/biomedisa/start_workers.sh
# Reason to target all interfaces(0.0.0.0) instead of the localhost or
# loopback address is described in this post:
# https://stackoverflow.com/questions/49476217/docker-cant-access-django-server
python3 /home/biomedisa/manage.py runserver 0.0.0.0:8888
