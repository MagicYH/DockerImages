FROM java

MAINTAINER magic

ENV BASE_PATH /usr/local/software

COPY cmd.sh /cmd.sh
RUN /bin/bash /cmd.sh

EXPOSE 2181
EXPOSE 9092
CMD supervisord -n -c /etc/supervisord.conf