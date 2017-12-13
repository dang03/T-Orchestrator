#!/bin/bash

#github
#https://github.com/sameersbn/docker-postgresql

git clone https://github.com/sameersbn/docker-postgresql.git
cd docker-postgresql
docker build -t="$USER/postgresql" .
