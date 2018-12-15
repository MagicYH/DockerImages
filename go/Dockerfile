FROM centos:7

MAINTAINER magic

ENV BASE_PATH /usr/local/software

ENV GO_VERSION go1.11.3

ENV GO_HOME=$BASE_PATH/$GO_VERSION
ENV PATH=${GO_HOME}/bin:$PATH

COPY cmd.sh /cmd.sh
RUN /bin/bash /cmd.sh

EXPOSE 80