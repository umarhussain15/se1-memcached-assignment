FROM ubuntu:16.04
      
MAINTAINER Umar Hussain <umar.hussain@mailbox.tu-dresden.de>

# ssh key of the host
ARG SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMMTIri0+9athLz2rqBjz25/IY5NNAZbxqCv4PhQZQsckXhWVzMSwsouryiA+JAgN/lFLaOrJGYQGNB4dzQF+fK8zn9LSspj0HORe2U8fbQNWm0h7MzzDGU0nF8zN1Wy6wCQ9IreSB4tE/C785ApPQnY0YVLJN+y2xA1tQFOXpNOihHH6Mc6Kray48HGvmLKw1u4cmeXpTXUlpDEHjfwcxG4PN16vaO4vvWJEpDLNBv+O2lY/Fn2Qt/JqSBhOeTVSXLkbYqfhCq7q6YyVBEKszNX+Jq/UPIkJoeMiMNNzdJ9zYfDo+2nGzLirBI6JTwo87vsPiljGYnBM47E4bX2Gc8JNbXFXXf9yqKggmlDqKDEHmX0GbPHPhG79OFG5MFXPfjrsJs3k5kZiiIKhaxqRzfNMJ9Ij4Bs1b2m+cU/DNCOCckvypmY6fdN+GMuB03aE1cqxEZOyGk9XW4o9GYN95TwreR4R7feaxlz6OHcMC1JRQzdMotZA3XW67HzftR7kuhe3PXfLmMNQM9P7mRrVvZBJcQnxUYt+nFBhjkWztQtRMvSNlDHU7TgpDxoHSE3gyxetPfbitkRelnK0mhl5uSjZKCppYx1IVXzSTsM/5ZsPNNa7H9crP+7AQ591BO0bIoDkBIPRTSBKY6vAdWk3kCQ5JT23z70yrpFbNyAHzzw== wojciech.ozga@tu-dresden.de"
ARG TEST_SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDww0jopFKF3pBc+tfe6mijV38+0hGh4FnWM5gnmDxhhtTb/1CuHwGi0y3tG95pXK4cfKU0oYVhfBj/2UryoBJqh5miUJUuMul5wP61Y9c8rAl6dvxn4ZP5bCcGq80J679s5cntrRNivxXlZ+UusDISBrzKK+F+B333DsjpAy3YEuZ9wyZfigZXl0UeDMprvw8eBVHHvGtNN3auAPkV3UcwN2Ltv13bSHt/6clxE5S6PkbNnDQe/46tNrRzInH+mdqWRNCKuCM9bBzGoTfIgO25vyU69Pdm993eOap5pddTfYmAMoxsfUN+mk+vOl6I8walJuh4QK1CFnpFFZmRYBIt se1a2p21"
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
    echo "$SSH_KEY\n$TEST_SSH_KEY" >> /home/ubuntu/.ssh/authorized_keys && \
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