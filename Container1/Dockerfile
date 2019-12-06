FROM ubuntu:16.04
      
MAINTAINER Umar Hussain <umar.hussain@mailbox.tu-dresden.de>

ARG MEMECAHCED_VERSION=1.4.33

# ssh key of the host
ARG SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMMTIri0+9athLz2rqBjz25/IY5NNAZbxqCv4PhQZQsckXhWVzMSwsouryiA+JAgN/lFLaOrJGYQGNB4dzQF+fK8zn9LSspj0HORe2U8fbQNWm0h7MzzDGU0nF8zN1Wy6wCQ9IreSB4tE/C785ApPQnY0YVLJN+y2xA1tQFOXpNOihHH6Mc6Kray48HGvmLKw1u4cmeXpTXUlpDEHjfwcxG4PN16vaO4vvWJEpDLNBv+O2lY/Fn2Qt/JqSBhOeTVSXLkbYqfhCq7q6YyVBEKszNX+Jq/UPIkJoeMiMNNzdJ9zYfDo+2nGzLirBI6JTwo87vsPiljGYnBM47E4bX2Gc8JNbXFXXf9yqKggmlDqKDEHmX0GbPHPhG79OFG5MFXPfjrsJs3k5kZiiIKhaxqRzfNMJ9Ij4Bs1b2m+cU/DNCOCckvypmY6fdN+GMuB03aE1cqxEZOyGk9XW4o9GYN95TwreR4R7feaxlz6OHcMC1JRQzdMotZA3XW67HzftR7kuhe3PXfLmMNQM9P7mRrVvZBJcQnxUYt+nFBhjkWztQtRMvSNlDHU7TgpDxoHSE3gyxetPfbitkRelnK0mhl5uSjZKCppYx1IVXzSTsM/5ZsPNNa7H9crP+7AQ591BO0bIoDkBIPRTSBKY6vAdWk3kCQ5JT23z70yrpFbNyAHzzw== wojciech.ozga@tu-dresden.de"
ARG TEST_SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDww0jopFKF3pBc+tfe6mijV38+0hGh4FnWM5gnmDxhhtTb/1CuHwGi0y3tG95pXK4cfKU0oYVhfBj/2UryoBJqh5miUJUuMul5wP61Y9c8rAl6dvxn4ZP5bCcGq80J679s5cntrRNivxXlZ+UusDISBrzKK+F+B333DsjpAy3YEuZ9wyZfigZXl0UeDMprvw8eBVHHvGtNN3auAPkV3UcwN2Ltv13bSHt/6clxE5S6PkbNnDQe/46tNrRzInH+mdqWRNCKuCM9bBzGoTfIgO25vyU69Pdm993eOap5pddTfYmAMoxsfUN+mk+vOl6I8walJuh4QK1CFnpFFZmRYBIt se1a2p21"

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y wget build-essential openssh-server && \
    # Install libevent (required for memcached) and install memcahced
    wget "https://github.com/libevent/libevent/releases/download/release-2.1.10-stable/libevent-2.1.10-stable.tar.gz" && \
    tar -zxf libevent-2.1.10-stable.tar.gz && \
    cd libevent-2.1.10-stable && \
    ./configure --prefix=/usr --disable-static && make && make install && \
    cd .. && \
    wget "http://www.memcached.org/files/memcached-$MEMECAHCED_VERSION.tar.gz" && \
    tar -zxf memcached-$MEMECAHCED_VERSION.tar.gz && \
    cd memcached-$MEMECAHCED_VERSION && \
    ./configure && \
    make && make install && \
    apt-get remove wget -y && apt autoremove -y

COPY entrypoint.sh /

RUN useradd -ms /bin/bash ubuntu
USER ubuntu
WORKDIR /home/ubuntu

# Add public key of host as authorized key
RUN mkdir /home/ubuntu/.ssh && \
    echo "$SSH_KEY\n$TEST_SSH_KEY" > /home/ubuntu/.ssh/authorized_keys && \
    chmod 0600 /home/ubuntu/.ssh/authorized_keys && echo $SSH_KEY
ENV PORT 2203
EXPOSE 11211 $PORT
CMD "/entrypoint.sh"
