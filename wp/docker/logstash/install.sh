#!/bin/bash

docker run -d \
  --name logstash \
  -p 9292:9292 \
  -p 9200:9200 \
  -p 9998:9998 \
  -p 5229:5229/udp \
  -v ~/workspace/tnova/WP3/docker/logstash/logstash.config:/opt/logstash.conf \
  pblittle/docker-logstash

docker run -d \
  --name logstash \
  -p 9292:9292 \
  -p 9200:9200 \
  -p 9998:9998 \
  -p 5229:5229/udp \
  -p 9999:9999/udp \
  -v ~/workspace/tnova/WP3/docker/logstash/logstash2.config:/opt/logstash/conf.d/logstash.conf \
  pblittle/docker-logstash
