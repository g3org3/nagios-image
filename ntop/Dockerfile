FROM nimmis/apache-php5

RUN wget http://apt-stable.ntop.org/14.04/all/apt-ntop-stable.deb
RUN dpkg -i apt-ntop-stable.deb
RUN apt-get clean all
RUN apt-get update
RUN apt-get install pfring nprobe ntopng ntopng-data n2disk nbox
