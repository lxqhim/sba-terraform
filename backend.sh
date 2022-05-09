#!/bin/bash
sudo yum update -y
sudo yum install docker -y
systemctl enable docker
systemctl start docker
docker pull lxqhim/smart-bank-api-server:v1
docker run -d --name springboot -e spring.datasource.url=jdbc:postgresql://lucas-db.cz6pjwcofgn8.us-west-1.rds.amazonaws.com:5432/smartbankapp -p 8080:8080 lxqhim/smart-bank-api-server:v1