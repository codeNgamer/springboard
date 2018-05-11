FROM centos:7.4.1708

RUN yum update -y

# install sudo and curl
RUN yum install -y curl sudo 

# install deps
RUN sudo yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel expat-devel wget centos-release-scl fontconfig freetype freetype-devel fontconfig-devel libstdc++ yum-utils device-mapper-persistent-data lvm2 libffi-devel bzip2 

RUN curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -

RUN sudo yum-config-manager --enable rhel-server-rhscl-7-rpms

# install devtoolset and nodejs
RUN sudo yum install -y devtoolset-7 nodejs

RUN scl enable devtoolset-7 bash

# Python 2.7.14:
RUN wget http://python.org/ftp/python/2.7.14/Python-2.7.14.tar.xz
RUN tar xf Python-2.7.14.tar.xz
WORKDIR Python-2.7.14
RUN ./configure --prefix=/usr/local --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
RUN make && make altinstall

# PIP
WORKDIR /
RUN wget https://bootstrap.pypa.io/get-pip.py


# Strip the Python 2.7 binary:
RUN strip /usr/local/lib/libpython2.7.so.1.0
# Strip the Python 3.6 binary:
# RUN strip /usr/local/lib/libpython3.6m.so.1.0

# Then execute it using Python 2.7 and/or Python 3.6:
RUN python2.7 get-pip.py

# install phantomjs
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN mkdir -p /opt 
RUN bunzip2 phantomjs*.tar.bz2
RUN tar xvf phantomjs*.tar
RUN mv phantomjs* /opt 
RUN sudo ln -s /opt/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/share/phantomjs
RUN sudo ln -s /opt/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs
RUN sudo ln -s /opt/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/bin/phantomjs
RUN pip install pyopenssl pyasn1
RUN pip install requests[security]

# add docker repo
RUN sudo yum-config-manager --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

# install docker
RUN sudo yum install -y docker-ce

# install docker-compose
RUN sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

RUN sudo chmod +x /usr/local/bin/docker-compose

RUN echo 'Springboard ready :)'
