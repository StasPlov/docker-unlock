#!/bin/bash

# New JSON content to add
new_mirrors=(
  "https://dockerhub.timeweb.cloud".
  "https://mirror.gcr.io"
  "https://daocloud.io"
  "https://c.163.com"
  "https://huecker.io"
  "https://registry.docker-cn.com"
)

if [ -f /etc/docker/daemon.json ]; then
  echo "File /etc/docker/daemon.json exists. Updating the content."
  current_mirrors=$(grep -oP '(?<="registry-mirrors": \[)[^]]*' /etc/docker/daemon.json | tr -d ' \n' | tr ',' '\n' | tr -d '"')
else
  echo "File /etc/docker/daemon.json does not exist. Creating a new file."
  current_mirrors=""
fi

combined_mirrors=$(echo -e "$current_mirrors\n${new_mirrors[*]}" | tr ' ' '\n' | sort | uniq)

new_content="{\n  \"registry-mirrors\": [\n"
for mirror in $combined_mirrors; do
  new_content+="    \"$mirror\",\n"
done

new_content=$(echo -e "$new_content" | sed '$ s/,$//')
new_content=$(echo -e "$new_content" | sed '$ s/,$//')
new_content="${new_content}\n  ]\n}"

echo -e "$new_content" | sudo tee /etc/docker/daemon.json > /dev/null

# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NOCOLOR='\033[0m'

while true; do
    read -p "Restart Docker now? (y/N): "
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo systemctl restart docker
		echo
		echo -e "${GREEN}Docker restarted.${NOCOLOR}"
        break
    elif [[ $REPLY =~ ^[Nn]$ ]] || [[ -z $REPLY ]]; then
		echo
        echo -e "${YELLOW}Docker was not restarted. Please restart it manually to apply changes.${NOCOLOR}"
        break
	fi
done
