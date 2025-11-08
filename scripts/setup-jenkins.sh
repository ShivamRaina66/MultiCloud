#!/bin/bash
set -e
sudo apt update -y
sudo apt install -y openjdk-17-jdk wget gnupg2
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update -y
sudo apt install -y jenkins docker.io ansible git
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
echo "Jenkins setup script completed."
