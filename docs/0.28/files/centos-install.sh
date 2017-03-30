#!/usr/bin/env bash

# Five Minute Install of Sensu for CentOS
# (TODO: wrap the other script and make this unneccessary by making everything cross-platform enough)

# Make sure EPEL is installed and things are up to date
sudo yum install epel-release -y
sudo yum update -y

# Add the official Sensu repo
echo '[sensu]
name=sensu
baseurl=https://sensu.global.ssl.fastly.net/yum/$releasever/$basearch/
gpgcheck=0
enabled=1' | sudo tee /etc/yum.repos.d/sensu.repo

# Install our Redis data store
sudo yum install redis -y

# Install the Sensu server and client components
sudo yum install sensu -y

# Install a helper utility for parsing JSON
sudo yum install jq -y

# Put default configs in place
   sudo curl -o /etc/sensu/config.json https://sensuapp.org/docs/0.28/files/simple-sensu-config.json
   sudo curl -o /etc/sensu/conf.d/client.json https://sensuapp.org/docs/0.28/files/simple-client-config.json
   sudo curl -o /etc/sensu/dashboard.json https://sensuapp.org/docs/0.28/files/simple-dashboard-config.json

# ... make sure everything is properly owned ...
   sudo chown -R sensu:sensu /etc/sensu

# ... and start our services!
   sudo systemctl start sensu-server.service
   sudo systemctl start sensu-api.service
   sudo systemctl start sensu-client.service

 # Boom!
 curl -s http://127.0.0.1:4567/clients | jq . 
