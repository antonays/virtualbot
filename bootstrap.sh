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
sudo apt-get install build-essential -y
sudo apt-get install python-catkin-pkg -y

curl -sL https://raw.githubusercontent.com/brainsik/virtualenv-burrito/master/virtualenv-burrito.sh | $SHELL
source ~/.venvburrito/startup.sh
mkvirtualenv dotbot
workon dotbot


if [ ! -d "$VIRTUAL_ENV/project" ]; then
  mkdir $VIRTUAL_ENV/project
  ln -s /vagrant/code/webapp $VIRTUAL_ENV/project/webapp
fi

if [ ! -d "$VIRTUAL_ENV/ros" ]; then
  mkdir -p $VIRTUAL_ENV/ros/dotbot_ws/src
  bash
  source /opt/ros/kinetic/setup.bash
  cd $VIRTUAL_ENV/ros/dotbot_ws/src
  catkin_init_workspace
  ln -s /vagrant/code/dotbot_ros ./dotbot_ros
  cd ..
  catkin_make
  catkin_make install -DCMAKE_INSTALL_PREFIX=/opt/ros/kinetic
  exit
fi
