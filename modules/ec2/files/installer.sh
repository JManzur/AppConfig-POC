#!/bin/bash

# Move files to destination:
sudo mkdir -p /opt/sitcom_api
sudo chmod -R 777 /opt/sitcom_api
sudo mv /tmp/requirements.txt /opt/sitcom_api/
sudo mv /tmp/sitcom_api.py /opt/sitcom_api/
sudo mv /tmp/api_gunicorn_config.py /opt/sitcom_api/
sudo mv /tmp/api.sh /opt/sitcom_api/

# Install requirements and start the application:
cd /opt/sitcom_api/
sudo pip3 install --upgrade pip
sudo pip3 install --no-cache-dir -r requirements.txt
sleep 10s
sudo chmod +x api.sh
/bin/bash ./api.sh start

# Set the cron job to start the app on boot:
crontab -l > apicron
echo "@reboot sleep 60 /opt/sitcom_api/api.sh start" >> apicron
crontab apicron
rm apicron