# build on top of the latest LTS
FROM ubuntu:trusty
MAINTAINER You "salih@utappia.org"

# Update the package list info
RUN apt-get update

# Upgrade base distro to the latest versions of packages
RUN apt-get -o Dpkg::Options::="--force-confnew" --force-yes -fuy dist-upgrade

# Install the dependencies
RUN apt-get install -y apache2 php5 php5-gd php5-imagick php-xml-parser php5-intl php5-json php5-mcrypt mariadb-server libapache2-mod-php5 smbclient curl libcurl3 php5-curl bzip2 wget

# Do some cleanup
RUN apt-get -y autoremove
RUN apt-get -y clean
RUN apt-get -y autoclean

# Get the latest Owncloud and extract it to the web server folder
RUN wget -O - https://download.owncloud.org/community/owncloud-8.2.1.tar.bz2 | tar jx -C /var/www/

# Give the permissions to apache
RUN chown -R www-data:www-data /var/www/owncloud
ADD addPermissions.sh /root/addPermissions.sh
RUN chmod +x /root/addPermissions.sh
RUN /root/addPermissions.sh

# Enable the site
ADD ./001-owncloud.conf /etc/apache2/sites-available/
RUN ln -s /etc/apache2/sites-available/001-owncloud.conf /etc/apache2/sites-enabled/
RUN a2enmod rewrite

# Tell Docker to NAT port 80 on the host to the container when it’s run
EXPOSE :80

# Start Apache’s httpd in the foreground is so that Docker can manage the process
CMD ["/usr/sbin/apache2ctl", "-D",  "FOREGROUND"]
