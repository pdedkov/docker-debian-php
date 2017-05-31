FROM debian:latest
MAINTAINER Pavel E. Dedkov <pavel.dedkov@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

# env
ENV TIMEZONE Europe/Moscow

RUN apt-get update && apt-get install -y apt-transport-https && echo "deb http://packages.sury.org/php jessie main" > /etc/apt/sources.list.d/sury.list && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AC0E47584A7A714D

# install required software
RUN apt-get update \ 
&& apt-get upgrade -y \
&& apt-get install -y --no-install-recommends ca-certificates php7.1-cli php7.1-curl php-redis php7.1-mysql php7.1-sqlite3 php-mongodb php7.1-readline php7.1-tidy  php7.1-intl php7.1-mbstring php7.1-bcmath php7.1-xml  php-imagick php7.1-soap php-xdebug \
&& apt-get autoclean \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# configure php
RUN sed -i "/;date.timezone /c date.timezone = ${TIMEZONE}" /etc/php/7.1/cli/php.ini \
&& sed -i "/^short_open_tag /c short_open_tag = On" /etc/php/7.1/cli/php.ini

COPY xdebug.ini /etc/php/7.1/mods-available/
ENTRYPOINT ["/usr/bin/php"]
CMD ["-v"]
