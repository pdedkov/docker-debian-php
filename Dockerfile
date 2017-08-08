FROM debian:latest
MAINTAINER Pavel E. Dedkov <pavel.dedkov@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

# env
ENV TIMEZONE Europe/Moscow
ENV PHP_VERSION 7.1
ENV PHP_DIR /etc/php/$PHP_VERSION


RUN apt-get update && apt-get install -y gnupg apt-transport-https && echo "deb http://packages.sury.org/php stretch main" > /etc/apt/sources.list.d/sury.list && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AC0E47584A7A714D

# install required software
RUN apt-get update \ 
&& apt-get upgrade -y \
&& apt-get install -y --no-install-recommends git mercurial ca-certificates php${PHP_VERSION}-cli php${PHP_VERSION}-curl php-redis ${PHP_VERSION}-mysql ${PHP_VERSION}-sqlite3 php-mongodb ${PHP_VERSION}-readline ${PHP_VERSION}-tidy  ${PHP_VERSION}-intl ${PHP_VERSION}-mbstring ${PHP_VERSION}-bcmath ${PHP_VERSION}-xml  php-imagick ${PHP_VERSION}-soap php-xdebug g++ make php${PHP_VERSION}-dev \
&& apt-get autoclean \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# configure php
RUN sed -i "/;date.timezone /c date.timezone = ${TIMEZONE}" $PHP_DIR/cli/php.ini \
&& sed -i "/^short_open_tag /c short_open_tag = On" $PHP_DIR/cli/php.ini

COPY xdebug.ini $PHP_DIR/cli/conf.d/20-xdebug.ini
# composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php --install-dir=/bin --filename=composer

# pinba
RUN git clone https://github.com/tony2001/pinba_extension /tmp/pinba_extension \
    && cd /tmp/pinba_extension \
    && phpize \
    && ./configure --enable-pinba \
    && make install

RUN apt-get remove --purge -y  g++ make php${PHP_VERSION}-dev
COPY pinba.ini $PHP_DIR/cli/conf.d/20-pinba.ini

ENTRYPOINT ["/usr/bin/php"]
CMD ["-v"]
