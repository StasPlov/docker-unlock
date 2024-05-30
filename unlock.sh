#!/bin/bash

# Read content of existing /etc/docker/daemon.json if any
if [ -f /etc/docker/daemon.json ]; then
    current_content=$(cat /etc/docker/daemon.json)
else
    current_content='{}'
fi

new_mirrors='{
  "registry-mirrors" : [
    "https://mirror.gcr.io",
    "https://daocloud.io",
    "https://c.163.com",
    "https://huecker.io",
    "https://registry.docker-cn.com"
  ]
}'

# Merge content
merged_content=$(jq -s '.[0] * .[1]' <(echo "$current_content") <(echo "$new_mirrors"))

echo "$merged_content" | sudo tee /etc/docker/daemon.json > /dev/null

sudo systemctl restart docker