FROM debian
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install ssh wget vim npm apache2 lsof redis-server systemctl net-tools sudo ufw php php-curl php-cli php-fpm php-json php-common php-mysql php-zip php-gd php-mbstring  php-xml php-pear php-bcmath -y
RUN npm install -g wstunnel
RUN mkdir /run/sshd 
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN a2enmod proxy_wstunnel
RUN a2enmod rewrite
RUN wget https://raw.githubusercontent.com/yinzhidong/imok/master/apache2-default.conf
RUN wget https://raw.githubusercontent.com/yinzhidong/imok/master/redis-6.conf
RUN rm /etc/apache2/sites-available/000-default.conf
RUN mv apache2-default.conf 000-default.conf
RUN mv 000-default.conf /etc/apache2/sites-available
RUN rm /etc/redis/redis.conf
RUN mv redis-6.conf redis.conf
RUN mv redis.conf /etc/redis
RUN echo 'echo i am ok!' >/var/www/html/index.html
RUN echo 'wstunnel -s 0.0.0.0:8989 & ' >>/luo.sh
RUN echo 'service redis-server restart' >>/luo.sh
RUN echo 'service mysql restart' >>/luo.sh
RUN echo 'service apache2 restart' >>/luo.sh
RUN echo '/usr/sbin/sshd -D' >>/luo.sh
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config 
# RUN touch /etc/sysconfig/iptables
# RUN echo '-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT' >>/etc/sysconfig/iptables
# RUN echo '-A INPUT -m state --state NEW -m tcp -p tcp --dport 6379 -j ACCEPT' >>/etc/sysconfig/iptables
RUN echo root:echoyin|chpasswd
RUN chmod 755 /luo.sh
EXPOSE 80
EXPOSE 6379
CMD  /luo.sh