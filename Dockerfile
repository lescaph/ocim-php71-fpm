FROM debian:jessie
MAINTAINER Antoine Marchand <antoine@svilupo.fr>

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /tmp

# Install utils
RUN \
  apt-get update && \
  apt-get -y install wget \
                curl \
                apt-utils \
                ssmtp \
                xz-utils \
                libxrender-dev \
                apt-transport-https \
                lsb-release \
                ca-certificates \
                git && \

# Configure git
  git config --global url."https://".insteadOf git:// && \

# Configure suryb sources
  mkdir -p /run/php && \
  wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
  echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
  apt-get update && \
  apt install --no-install-recommends -y php7.1-fpm \
                php7.1 \
                php7.1-mysql \
                php7.1-sqlite3 \
                php7.1-pgsql \
                php7.1-curl \
                php7.1-mcrypt \
                php7.1-intl \
                php7.1-bz2 \
                php7.1-imap \
                php7.1-gd \
                php7.1-json \
                php7.1-xdebug \
                php7.1-mbstring \
                php7.1-ldap \
                php7.1-zip \
                php7.1-xml && \
               # php7.0-dev && \

# INSTALL NODEJS NPM BOWER GULP
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm && \
    npm install -g bower && \
    npm install -g gulp && \

# INSTALL WKHTMLTOPDF
    wget https://downloads.wkhtmltopdf.org/0.12/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz && \
    tar xf wkhtmltox-0.12.3_linux-generic-amd64.tar.xz && \
    cp wkhtmltox/bin/wkhtmltopdf /usr/local/bin/ && \

# INSTALL COMPOSER
    php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"  && \

# CONFIGURE PHP
    #mkdir "/run/php" && \
    sed -i -e "s/;daemonize = yes/daemonize = no/g" /etc/php/7.1/fpm/php-fpm.conf && \
    sed -i "s/listen = \/run\/php\/php7.1-fpm.sock/listen = 0.0.0.0:9002/g" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/"                  /etc/php/7.1/fpm/php.ini && \
    sed -i "s/;date.timezone =.*/date.timezone = Europe\/Paris/"        /etc/php/7.1/fpm/php.ini 

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9002

CMD ["php-fpm7.1", "-F"]
