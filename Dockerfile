FROM nimmis/apache-php5

RUN useradd nagios
RUN groupadd nagcmd
RUN usermod -a -G nagcmd nagios
RUN apt-get update
RUN apt-get install -y build-essential libgd2-xpm-dev openssl libssl-dev xinetd apache2-utils unzip

WORKDIR /root
RUN curl -L -O https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.1.1.tar.gz
RUN tar xvf nagios-*.tar.gz
RUN cd nagios-* && ./configure --with-nagios-group=nagios --with-command-group=nagcmd

WORKDIR /root/nagios-4.1.1

RUN make all

RUN make install
RUN make install-commandmode
RUN make install-init
RUN make install-config
RUN /usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-available/nagios.conf

RUN usermod -G nagcmd www-data

WORKDIR /root
RUN curl -L -O http://nagios-plugins.org/download/nagios-plugins-2.1.1.tar.gz
RUN tar xvf nagios-plugins-*.tar.gz

WORKDIR /root/nagios-plugins-2.1.1
RUN ./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl
RUN make
RUN make install

WORKDIR /root
RUN curl -L -O http://downloads.sourceforge.net/project/nagios/nrpe-2.x/nrpe-2.15/nrpe-2.15.tar.gz
RUN tar xvf nrpe-*.tar.gz

WORKDIR /root/nrpe-2.15
RUN ./configure --enable-command-args --with-nagios-user=nagios --with-nagios-group=nagios --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu
RUN make all
RUN make install
RUN make install-xinetd
RUN make install-daemon-config
RUN apt-get install -y vim

COPY ./config/nrpe /etc/xinetd.d/nrpe
COPY ./config/nagios.cfg /usr/local/nagios/etc/nagios.cfg

RUN mkdir /usr/local/nagios/etc/servers

COPY ./config/commands.cfg /usr/local/nagios/etc/objects/commands.cfg

RUN a2enmod rewrite
RUN a2enmod cgi

RUN echo "Ab1234" >> htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
RUN ln -s /etc/apache2/sites-available/nagios.conf /etc/apache2/sites-enabled/

#RUN service nagios start
#RUN service apache2 restart

RUN ln -s /etc/init.d/nagios /etc/rcS.d/S99nagios

COPY ./app/index.php /var/www/html/index.php
COPY ./var/init.sh /var/local/init.sh
WORKDIR /var/local/
