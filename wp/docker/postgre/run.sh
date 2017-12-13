#!/bin/bash

DB='tnova_orchestrator'
USER='tnova'
PASS='i2cat'

#sudo docker run -p 5432:5432 --name postgresql -e 'DB_NAME=tnova_orchestrator' -e 'DB_USER=tnova' -e 'DB_PASS=i2cat' -v /opt/postgresql/data:/var/lib/postgresql sameersbn/postgresql:9.4-2
sudo docker run -p 5432:5432 --name postgresql -d -e 'DB_NAME=$(DB)' -e 'DB_USER=$(USER)' -e 'DB_PASS="$(PASS)' -v /opt/postgresql/data:/var/lib/postgresql sameersbn/postgresql:9.4-2
