FROM alpine:3.19
LABEL maintainer="Gaston Martres <gaston@gastonmartres.com>" \ 
      version="0.2" \
      description="Docker image for running minecraft server, optimized to be used in a raspberry pi 4 4Gb."  

WORKDIR /opt/
COPY minecraft minecraft

RUN apk add openjdk21-jre --no-cache \ 
	&& rm -f /var/cache/apk/* \ 
	&& addgroup -S -g 1000 minecraft \ 
	&& adduser -S -u 1000 minecraft

RUN chown minecraft:minecraft /opt/minecraft
WORKDIR /opt/minecraft
USER minecraft
EXPOSE 25565 25575
ENTRYPOINT ["java","-Xmx3G","-Xms3G","-XX:+UseG1GC","-XX:MaxGCPauseMillis=50","-XX:ParallelGCThreads=2","-jar","server.jar","nogui"]