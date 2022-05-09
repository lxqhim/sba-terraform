#!/bin/bash
sudo yum update -y
sudo yum install docker -y
systemctl enable docker
systemctl start docker
docker pull abhay1813/finalfrontend
docker run -d -p 80:3000 -e REACT_APP_API_URL=http://lucas-nlb-3ad5b7b84757e76f.elb.us-west-1.amazonaws.com:8080/ abhay1813/finalfrontend