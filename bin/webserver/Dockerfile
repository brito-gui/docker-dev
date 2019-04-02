FROM php:7.1-apache

# Install dependencies
RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends gnupg \
    unzip libssl-dev libpcre3 libpcre3-dev libxml2-dev libmemcached-dev git \
    build-essential ssh python-setuptools python-pip groff-base libmcrypt-dev \
    libicu-dev zlib1g-dev

# Self-signed certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/ssl-cert-snakeoil.key \
    -out /etc/ssl/certs/ssl-cert-snakeoil.pem \
    -subj "/C=AT/ST=Vienna/L=Vienna/O=Security/OU=Development/CN=example.com"

# Apache modules
RUN a2enmod rewrite \
    && a2enmod ssl \
    && a2enmod headers \
    && a2enmod status \
    && a2enmod deflate \
    && a2enmod mime \
    && a2enmod expires \
    && a2dismod 'mpm_*' \
    && a2enmod mpm_prefork

# Install memcached extension / PHP libs
RUN pecl install xdebug-2.5.5 memcached-3.0.4 \
    && docker-php-ext-enable xdebug memcached \
    && docker-php-ext-install opcache zip intl -j$(nproc) mcrypt pdo_mysql sockets soap

# Install NodeJS 8.11.4
RUN curl -O https://nodejs.org/dist/v8.11.4/node-v8.11.4-linux-x64.tar.xz \
    && mkdir /usr/local/lib/nodejs \
    && tar -xJf node-v8.11.4-linux-x64.tar.xz -C /usr/local/lib/nodejs \
    && rm node-v8.11.4-linux-x64.tar.xz \
    && export NODEJS_HOME=/usr/local/lib/nodejs/node-v8.11.4-linux-x64/bin \
    && export PATH=$NODEJS_HOME:$PATH \
    && ln -s /usr/local/lib/nodejs/node-v8.11.4-linux-x64/bin/node /usr/bin/node \
    && ln -s /usr/local/lib/nodejs/node-v8.11.4-linux-x64/bin/npm /usr/bin/npm

# Yarn
RUN cd $HOME \
    && curl -O -o- -L https://yarnpkg.com/install.sh \
    && sh ./install.sh -s -- --version 1.12.3 \
    && export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH" \
    && ln -s $HOME/.yarn/bin/yarn /usr/bin/yarn

# Composer installation
    RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Entrypoint
COPY docker-entrypoint.sh /bin/docker-entrypoint.sh
RUN chmod +x /bin/docker-entrypoint.sh
ENTRYPOINT ["/bin/docker-entrypoint.sh"]
