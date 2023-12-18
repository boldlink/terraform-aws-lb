#!/bin/bash

sudo yum update -y
sudo yum install httpd -y
sudo service httpd start
sudo chkconfig httpd on
sudo systemctl status httpd
sudo touch /var/www/html/index.html
sudo chmod 777 /var/www/html -R
sudo echo Your sample app page is working well! > /var/www/html/index.html
