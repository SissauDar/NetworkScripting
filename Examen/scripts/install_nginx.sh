#! /bin/bash
sudo apt-get update
sudo apt-get install -y nginx
sudo rm -rf /etc/nginx/sites-enabled/default 
sudo cat /tmp/load-balancing.conf > /etc/nginx/conf.d/load-balancing.conf 
sudo service nginx restart
echo "<h1>Deployed via Terraform on webserver-$1</h1>" | sudo tee /var/www/html/index.html