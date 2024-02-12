#!/bin/bash
sudo apt-get update -y
sudo apt install python3-pip -y

sudo -su ubuntu bash<<EOFUBUNTU

sudo pip3 install virtualenv 
virtualenv /home/ubuntu/.local/airflow_env
sudo chmod -R 777 /home/ubuntu/.local/airflow_env
source /home/ubuntu/.local/airflow_env/bin/activate
pip3 install apache-airflow pyspark scikit-learn apache-airflow-providers-amazon mysql-connector-python
airflow db init
rm -rf /home/ubuntu/.local/airflow_env/lib/python3.8/site-packages/airflow/example_dags/*

airflow users create --username admin --password Password@airflow --firstname abhishek --lastname saini --role Admin --email abhishek1@tothenew.com
mkdir /home/ubuntu/airflow/dags


EOFUBUNTU


# Create the airflow-scheduler.service file
cat <<EOFSCHEDULER > /etc/systemd/system/airflow-scheduler.service
[Unit]
Description=Airflow scheduler daemon
[Service]
User=ubuntu
Group=ubuntu
Type=simple
ExecStart=/usr/bin/bash -c 'source /home/ubuntu/.local/airflow_env/bin/activate ; airflow scheduler;'
RestartSec=5s
PrivateTmp=true
[Install]
WantedBy=multi-user.target
EOFSCHEDULER

# Create the airflow-webserver.service file
cat <<EOFWEBSERVER > /etc/systemd/system/airflow-webserver.service
[Unit]
Description=Airflow webserver daemon
[Service]
User=ubuntu
Group=ubuntu
Type=simple
ExecStart=/usr/bin/bash -c 'source /home/ubuntu/.local/airflow_env/bin/activate ; airflow webserver;'
RestartSec=5s
PrivateTmp=true
[Install]
WantedBy=multi-user.target
EOFWEBSERVER

# Reload systemd configuration
sudo systemctl daemon-reload

# Start the services
sudo systemctl start airflow-scheduler
sudo systemctl start airflow-webserver

# Check the status
sudo systemctl status airflow-scheduler
sudo systemctl status airflow-webserver