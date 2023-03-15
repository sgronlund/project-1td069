#!/usr/bin/bash

sudo docker build --tag hadoop_master master/
sudo docker build --tag hadoop_worker worker/
sudo docker run -d --network host hadoop_master
sudo docker run -d --network host hadoop_worker
