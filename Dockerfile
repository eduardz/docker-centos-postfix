FROM muzili/centos-base:latest
MAINTAINER Joshua Lee <muzili@gmail.com>

RUN  yum install -y postfix cyrus-sasl-plain cyrus-sasl-md5

# Expose our data and log directories
VOLUME ["/data", "/var/log"]

ADD scripts /scripts
RUN chmod +x /scripts/*.sh && \
    touch /first_run

EXPOSE 25

# Kicking in
CMD ["/scripts/start.sh"]

