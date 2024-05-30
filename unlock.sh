#!/bin/bash

json_content='{
  "registry-mirrors" : [
    "https://mirror.gcr.io",
    "https://daocloud.io",
    "https://c.163.com",
    "https://huecker.io",
    "https://registry.docker-cn.com"
  ]
}'

echo "$json_content" | sudo tee /etc/docker/daemon.json > /dev/null

sudo systemctl restart docker