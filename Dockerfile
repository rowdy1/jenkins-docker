FROM jenkins/jenkins:lts
ARG JENKUID
ARG JENKGID
ARG DOCKGID
MAINTAINER 4oh4

# Derived from https://github.com/getintodevops/jenkins-withdocker (miiro@getintodevops.com)

USER root

# Install the latest Docker CE binaries and add user `jenkins` to the docker group
RUN apt-get update && \
    apt-get -y install apt-transport-https \
      ca-certificates \
      curl \
      gnupg2 \
      software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
      $(lsb_release -cs) \
      stable" && \
   apt-get update && \
   apt-get -y install docker-ce
   
RUN usermod -u $JENKUID jenkins && \
   groupmod -g $DOCKGID docker && \
   groupmod -g $JENKGID jenkins && \
   usermod -aG docker jenkins

# drop back to the regular jenkins user - good practice
USER jenkins
