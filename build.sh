# This build script will create the docker images for the Debian Jessie Linux Base Images
# 2 Images will be created, one bare, and the other including Ansible

# CD into the Main Project directory before launching this script

# Debian Jessie Base Container Image
cd base
docker build -t build/debian .
docker run -it -d --name debian build/debian /bin/bash
docker export debian | docker import - appcontainers/debian:latest
docker tag "appcontainers/debian:latest" "appcontainers/debian:jessie"
docker kill debian; docker rm debian
docker push "appcontainers/debian:latest"
docker push "appcontainers/debian:jessie"
docker images
docker rmi build/debian
docker rmi "appcontainers/debian:jessie"
docker rmi "appcontainers/debian:latest"

# Debian Jessie Base Container Image with Ansible
cd ../ansible
docker build -t build/debian .
docker run -it -d --name debian build/debian /bin/bash
docker export debian | docker import - appcontainers/debian:ansible
docker tag "appcontainers/debian:ansible" "appcontainers/debian:ansible-jessie"
docker kill debian; docker rm debian
docker push "appcontainers/debian:ansible"
docker push "appcontainers/debian:ansible-jessie"
docker images
docker rmi build/debian
docker rmi "appcontainers/debian:ansible-jessie"
docker rmi "appcontainers/debian:ansible"
docker rmi "library/debian:latest"