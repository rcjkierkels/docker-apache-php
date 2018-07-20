FROM php:7.2.7-apache-stretch
#FROM php:5.6.36-apache-stretch

LABEL maintainer="Roland Kierkels"

COPY config/php/php.ini /usr/local/etc/php/
COPY config/entrypoint.sh /sbin/entrypoint.sh

# ----------------------------------------------------
#  Install tools
# ----------------------------------------------------
RUN apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
		net-tools \
		openssh-server \
		nano \
		cron \
        iputils-ping \

        # required for PHP extension zip
        zlib1g-dev \
        # required for PHP extension ftp
        libssl-dev \
        # required for PHP extension curl
        libcurl3-dev \
        # required for PHP extension dom
        libxml2-dev \
        # required for PHP extension readline
        libedit-dev \
        # required for PHP extension gd
        libpng-dev

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# ----------------------------------------------------
#  Install PHP Extensions
# ----------------------------------------------------
RUN docker-php-ext-install pdo_mysql bcmath calendar ctype zip ftp curl dba dom json posix session exif fileinfo tokenizer
#enchant fileinfo filter ftp gd gettext gmp hash iconv imap interbase intl \
#ldap mbstring mysqli oci8 odbc opcache pcntl pdo pdo_dblib pdo_firebird pdo_oci pdo_odbc pdo_pgsql pdo_sqlite pgsql phar \
#pspell recode reflection shmop simplexml snmp soap sockets spl standard sysvmsg \
#sysvsem sysvshm tidy wddx xml xmlreader xmlrpc xmlwriter xsl

# Install XDebug
RUN pecl install xdebug-2.6.0 \
    && docker-php-ext-enable xdebug

# ----------------------------------------------------
#  Configure Apache
# ----------------------------------------------------
RUN sed -i "s/Listen 80/Listen 50080/" /etc/apache2/ports.conf
RUN sed -i "s/Listen 443/Listen 50443/" /etc/apache2/ports.conf
RUN a2enmod rewrite
RUN a2enmod vhost_alias
RUN rm /etc/apache2/sites-enabled/*
RUN rm /etc/apache2/sites-available/*
COPY config/apache2/vhost/* /etc/apache2/sites-available/
RUN cd /etc/apache2/sites-available;a2ensite *;

# ----------------------------------------------------
#  Configure OPENSSH server
# ----------------------------------------------------
RUN mkdir /var/run/sshd
RUN useradd -g www-data deployhq
RUN echo "deployhq:2SMx0eUi13pzKgv" | chpasswd

# Set default shell for new user
RUN usermod --shell /bin/bash deployhq
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN sed -i 's/#Port 22/Port 50022/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Make sure ssh server is started after boot
CMD ["/usr/sbin/sshd", "-D"]
CMD ["/sbin/entrypoint.sh"]