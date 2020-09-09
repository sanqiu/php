FROM akeneo/php:7.2
MAINTAINER Damien Carcel <damien.carcel@akeneo.com>

# Install PHP FPM
RUN apt-get update && \
    apt-get --no-install-recommends --no-install-suggests --yes --quiet install php7.2-fpm && \
    apt-get install --yes --quiet php7.2-bcmath php7.2-ctype php7.2-curl php7.2-dom php7.2-gd  php7.2-hash  php7.2-iconv  php7.2-intl  php7.2mbstring  php7.2-openssl  php7.2-pdo_mysql  php7.2-simplexml php7.2-soap php7.2-xsl php7.2-zip && \
    apt-get clean && apt-get --yes --quiet autoremove --purge && \
    rm -rf  /var/lib/apt/lists/* /tmp/* /var/tmp/* \
            /usr/share/doc/* /usr/share/groff/* /usr/share/info/* /usr/share/linda/* \
            /usr/share/lintian/* /usr/share/locale/* /usr/share/man/*

# Configure PHP FPM
RUN sed -i "s/user = www-data/user = docker/" /etc/php/7.2/fpm/pool.d/www.conf && \
    sed -i "s/group = www-data/group = docker/" /etc/php/7.2/fpm/pool.d/www.conf

RUN phpenmod akeneo
RUN phpdismod xdebug

RUN mkdir -p /run/php && sed -i "s/listen = .*/listen = 9001/" /etc/php/7.2/fpm/pool.d/www.conf

# Run FPM in foreground
CMD ["sudo", "php-fpm7.2", "-F"]
