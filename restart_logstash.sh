#!/bin/bash

sudo docker stop logstash
sudo docker rm logstash
sudo docker-compose up -d
