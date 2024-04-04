#!/bin/bash
docker volume create --name sonar-data
docker volume create --name sonar-logs
docker volume create --name sonar-extensions

$ docker run -d \
-p 8081:8081 --name nexus \
-v sonar-data:/opt/sonarqube/data \
-v sonar-logs:/opt/sonarqube/logs \
-v sonar-extensions:/opt/sonarqube/extensions \
 sonarqube