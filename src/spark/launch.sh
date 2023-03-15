#!/usr/bin/bash

# Simple shell script to launch and build all containers

docker build --tag spark_master master/
docker build --tag spark_worker worker/
docker run -d --network host spark_master
docker run -d --network host spark_worker
