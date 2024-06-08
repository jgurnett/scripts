#!/bin/bash
#-----------------------
# update portainer
# Author: Joel Gurnett
# Jan 4, 2022
#-----------------------

docker stop portainer
docker rm portainer
docker pull portainer/portainer-ce:$1
docker run -d -p 8000:8000 -p 9000:9000 -p 9443:9443 \
    --name=portainer --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce:$1

echo Upgraded to version $1!
