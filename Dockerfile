FROM debian
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install ssh wget npm apache2 redis-server systemctl net-tools sudo ufw -y
RUN npm install -g wstunnel
RUN mkdir /run/sshd 
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN a2enmod proxy_wstunnel
RUN a2enmod rewrite
RUN rm /etc/apache2/sites-available/000-default.conf
RUN mv ./apache2-default.conf /etc/apache2/sites-available
RUN rm /etc/redis/redis.conf
RUN mv ./redis.conf /etc/redis
RUN echo 'echo i am ok!' >/var/www/html/index.html
RUN echo 'wstunnel -s 0.0.0.0:8989 & ' >>/luo.sh
RUN echo 'service apache2 restart' >>/luo.sh
RUN echo 'service redis-server restart' >>/luo.sh
RUN echo '/usr/sbin/sshd -D' >>/luo.sh
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config 
RUN echo root:uncleluo|chpasswd
RUN chmod 755 /luo.sh
EXPOSE 80
EXPOSE 6379
CMD  /luo.sh