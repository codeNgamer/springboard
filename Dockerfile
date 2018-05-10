FROM centos:7.4.1708

RUN yum update -y

# install sudo and curl
RUN yum install -y curl sudo 

RUN curl --silent --location https://rpm.nodesource.com/setup_10.x | sudo bash -

# install nodejs and build-tools 
RUN sudo yum install -y nodejs gcc-c++ make

RUN sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# add docker repo
RUN sudo yum-config-manager --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

# install docker
RUN sudo yum install -y docker-ce

# install docker-compose
RUN sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

RUN sudo chmod +x /usr/local/bin/docker-compose

RUN echo 'Springboard ready :)'
