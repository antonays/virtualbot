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
sudo apt-get install git -y
sudo apt-get install build-essential -y
sudo apt-get install python-catkin-pkg -y
sudo apt-get install nginx -y

echo "finished basic framework installations ..."

sudo apt-get install python-pip -y
sudo apt-get install python-virtualenv -y
sudo pip install virtualenvwrapper
echo "finished pip, virtualenv, virtualenvwrapper installations ..."
sudo pip install uwsgi

source /usr/local/bin/virtualenvwrapper.sh
mkvirtualenv dotbot
echo "created workspace ..."
workon dotbot
deactivate
echo "exited from workspace ..."

if [ ! -d "~/project" ]; then
  echo "creating project directory ..."
  mkdir ~/project
  git clone https://github.com/dotbot-io/dotbot_ros
  echo "created project directory ..."
  echo "cloned ros directory to project ..."
fi

if [ ! -d "~/ros" ]; then
  echo "creating ros directory ..."
  mkdir -p ~/ros/dotbot_ws/src
  bash
  source /opt/ros/kinetic/setup.bash
  cd ~/ros/dotbot_ws/src
  catkin_init_workspace
  echo "initialized catkin workspace ..."
  git clone https://github.com/dotbot-io/dotbot_ros
  cd ..
  catkin_make
  echo "finished catkin_make ..."
  sudo su -c "source /opt/ros/kinetic/setup.bash; catkin_make install -DCMAKE_INSTALL_PREFIX=/opt/ros/kinetic"
  echo "installed ros directory ..."
fi

workon dotbot
mkdir ~/.virtualenvs/dotbot/project
cd ~/.virtualenvs/dotbot/project/
git clone https://github.com/dotbot-io/robot-manager.git
echo "cloned project manager application ..."
cd robot-manager/

pip install -r requirements.txt
echo "installed project dependencies ..."
deactivate

sudo rm -rf ~/ros/dotbot_ws/src/dotbot_ros
echo "removed source code from ros/src ..."
echo "Done installation"

# setup nginx server