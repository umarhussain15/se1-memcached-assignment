FROM ubuntu:16.04
      
MAINTAINER Umar Hussain <umar.hussain@mailbox.tu-dresden.de>

# ssh key of the host
ARG SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDchdx5nUhSBxXyUEsEhDAsdj49yCDj0gBAocIwzuRLQqrOicteDQelMc8dNC/SKqtFrIJYK3JUpP55h9aJYCqgKUD/jHWKuoE0likM14yrl0Kj4IeELES3xQSGnH9LqeDe+/tJ6G06PqQCcs0uUF+CzhJJdY+fQrJR2sndSiaE4et7b6HdY8KxDDp3/dOZg2leC2mwH9+m/g+31wOZBQpe34I0kuGOE5P8goOBSGlu8qKC8xReCpb7stnZBVV2jrXXQg20GMxylA8M3gGKKCegM3JweJJsEuEZ9NJ0ckDSj86EzCraQrb10CwjvDDw+uRhjWO12SkJdCUIkuN/EKP pc@DESKTOP-CNK9STR"

RUN apt-get update
RUN apt-get upgrade -y

# install build essentials and openssh server
RUN apt-get update && \
    apt-get install -qq build-essential software-properties-common wget openssh-server && \
    add-apt-repository ppa:jonathonf/python-3.6 && apt-get update -qq
# install mercurial and git
RUN apt-get install -y git mercurial

# install python
RUN apt-get install -y -qq python3.6 python3.6-dev python3-pip python3.6-venv

# install R
RUN apt-get install -qq r-base

# install mcperf
RUN wget "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/twemperf/mcperf-0.1.1.tar.gz" && \
    tar -zxf mcperf-0.1.1.tar.gz && \
    cd mcperf-0.1.1 && \
    ./configure && make && make install && \
    rm -fv mcperf-0.1.1.tar.gz

COPY entrypoint.sh /

# create user ubuntu and set it as docker user for this container
RUN useradd -ms /bin/bash ubuntu
USER ubuntu
WORKDIR /home/ubuntu

# add host public key to authorized key
RUN mkdir /home/ubuntu/.ssh && \
    echo "$SSH_KEY" > /home/ubuntu/.ssh/authorized_keys && \
    chmod 0600 /home/ubuntu/.ssh/authorized_keys && echo "$SSH_KEY"

# set user of these files to ubuntu
COPY --chown=ubuntu:ubuntu run.sh .
COPY --chown=ubuntu:ubuntu Dudefile .
COPY --chown=ubuntu:ubuntu Benchmark.py .
COPY --chown=ubuntu:ubuntu graphs.R .
#RUN chown ubuntu run.sh && chown ubuntu -R experiments/

ENV PORT 2022

EXPOSE 2022
CMD "/entrypoint.sh"