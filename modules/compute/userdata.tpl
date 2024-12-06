#!/bin/bash
sleep 20s
sudo yum update -y
sudo yum install httpd -y
sudo yum install wget -y
sudo yum install unzip -y
cd /var/www/html
wget https://github.com/wessamabdelwahab/CSCC1030/archive/master.zip
unzip master.zip
mv CSCC1030-master/*.* /var/www/html/
rm master.zip
service httpd start
