FROM alpine:3.4
MAINTAINER Simon Erhardt <hello@rootlogin.ch>

ENV DB_HOST="db" \
  DB_USER="icinga" \
  DB_NAME="icinga" \
  DB_PW="icinga"

RUN apk add --update \
  bash \
  icinga2 \
  icinga2-bash-completion \
  icingaweb2 \
  icingaweb2-bash-completion \
  mariadb-client \
  nginx \
  php5-fpm \
  py-pip \
  sudo \
  supervisor \
  tini \
  wget \
  && rm -rf /var/cache/apk/*

RUN pip install supervisor-stdout

RUN mkdir /run/icinga2 && chown -R icinga:icinga /run/icinga2
RUN mkdir -p /opt/icinga2 \
  && mkdir /opt/icinga2/default_config \
  && cp -r /etc/icinga2 /opt/icinga2/default_config/

COPY etc/icinga2/ido-mysql.conf /opt/icinga2/default_config/icinga2/features-available/ido-mysql.conf
COPY etc/supervisord.conf /etc/supervisord.conf
COPY bin/run.sh /opt/icinga2/run.sh

VOLUME ["/etc/icinga2"]

EXPOSE 80

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/opt/icinga2/run.sh"]
