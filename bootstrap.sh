#!/usr/bin/env bash
echo "starting ..."
echo $(whoami)
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install ros-kinetic-ros-base -y
sudo apt-get install ros-kinetic-rosbridge-suite -y
sudo apt-get install vim tmux -y
sudo apt-get install supervisor -y
sudo apt-get install curl -y

curl -sL https://raw.githubusercontent.com/brainsik/virtualenv-burrito/master/virtualenv-burrito.sh | $SHELL
source ~/.venvburrito/startup.sh
mkvirtualenv dotbot

ln -s /vragrant/code/ $VIRTUAL_ENV/code
