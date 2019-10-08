FROM debian:stretch
MAINTAINER Pavel E. Dedkov <pavel.dedkov@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

# env
ENV TIMEZONE Europe/Moscow
ENV PHP_VERSION 7.1
ENV PHP_DIR /etc/php/$PHP_VERSION

RUN apt-get update && apt-get install -y gnupg apt-transport-https && echo "deb http://packages.sury.org/php stretch main" > /etc/apt/sources.list.d/sury.list && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B188E2B695BD4743

# install required software
RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y --no-install-recommends git mercurial ca-certificates php${PHP_VERSION}-cli php${PHP_VERSION}-curl php-redis php${PHP_VERSION}-mysql php${PHP_VERSION}-sqlite3 php-mongodb php${PHP_VERSION}-readline php${PHP_VERSION}-tidy  php${PHP_VERSION}-intl php${PHP_VERSION}-mbstring php${PHP_VERSION}-bcmath php${PHP_VERSION}-xml  php-imagick php${PHP_VERSION}-soap php${PHP_VERSION}-pgsql php${PHP_VERSION}-gearman php-xdebug \
&& apt-get autoclean \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# configure php
RUN sed -i "/;date.timezone /c date.timezone = ${TIMEZONE}" $PHP_DIR/cli/php.ini \
&& sed -i "/^short_open_tag /c short_open_tag = On" $PHP_DIR/cli/php.ini

COPY xdebug.ini $PHP_DIR/cli/conf.d/20-xdebug.ini
# composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php --install-dir=/bin --filename=composer

ENTRYPOINT ["/usr/bin/php"]
CMD ["-v"]
