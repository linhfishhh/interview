#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
sudo ufw allow 'Nginx HTTP'

cd /var/www/html
echo "<html>" > index.html

echo "<h4 style='color:red;'>You are running instance from this IP (For debug only!!!!Do not public this to user):</h4>" >> index.html

export TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`

echo "<br>Private IP: " >> index.html
curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/local-ipv4 >> index.html