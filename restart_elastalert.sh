#!/bin/bash

sudo docker stop elastalert
sudo docker rm elastalert
sudo docker-compose up -d
sudo docker logs -f elastalert

