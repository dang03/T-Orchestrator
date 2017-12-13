#!/bin/bash

docker pull tobert/cassandra
mkdir /srv/cassandra
docker run -p 9042:9042 -p 9160:9160 -d -v /srv/cassandra:/data tobert/cassandra
