#!/bin/bash

cd /opt
git clone https://github.com/awsdevopsb01/roboshop-adv-shell.git
cd roboshop-adv-shell
bash rabbitmq.sh rabbitmq &>> /opt/roboshop.log
