#!/bin/bash

GITLAB_HOME=/opt

docker run -d -name gitlab --hostname gitlab.secura.net.ar \
-p 443:443 -p 80:80 -p 22:22 \
--restart always
-v $GITLAB_HOME/config:/etc/gitlab \
-v $GITLAB_HOME/logs:/var/log/gitlab \ 
-v $GITLAB_HOME/data:/var/opt/gitlab \
--shm-size 256m \
gitlab/gitlab-ee:latest


sleep 10
sudo docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password