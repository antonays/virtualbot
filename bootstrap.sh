#!/usr/bin/env bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`

echo "${yellow}starting ..."
echo "${yellow}i am $(whoami)"
echo "${yellow}================="
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
echo "${yellow}finished basic framework installations ..."

sudo apt-get install python-pip -y
sudo apt-get install python-virtualenv -y
sudo apt-get install avahi-deamon -y
sudo pip install virtualenvwrapper
sudo pip install uwsgi
echo "${yellow}finishd secondary framework installations ..."

source /usr/local/bin/virtualenvwrapper.sh
mkvirtualenv dotbot
echo "${yellow}created workspace - entering to test..."
workon dotbot
deactivate
echo "${yellow}exited from workspace ..."

if [ ! -d "~/project" ]; then
  echo "${yellow}creating project directory ..."
  mkdir ~/project
  git clone https://github.com/dotbot-io/dotbot_ros
  echo "${yellow}cloned ros directory to project ..."
fi

if [ ! -d "~/ros" ]; then
  echo "${yellow}creating ros directory ..."
  mkdir -p ~/ros/dotbot_ws/src
  bash
  source /opt/ros/kinetic/setup.bash
  cd ~/ros/dotbot_ws/src
  catkin_init_workspace
  echo "${yellow}initialized catkin workspace ..."
  git clone https://github.com/dotbot-io/dotbot_ros
  cd ..
  catkin_make
  echo "${yellow}finished catkin_make ..."
  sudo su -c "source /opt/ros/kinetic/setup.bash; catkin_make install -DCMAKE_INSTALL_PREFIX=/opt/ros/kinetic"
  echo "${yellow}installed ros directory in root..."
fi

workon dotbot
mkdir ~/.virtualenvs/dotbot/project
cd ~/.virtualenvs/dotbot/project/
git clone https://github.com/dotbot-io/robot-manager.git
echo "${yellow}cloned project manager application ..."
cd robot-manager/

pip install -r requirements.txt
echo "installed project dependencies ..."


sudo rm -rf ~/ros/dotbot_ws/src/dotbot_ros
echo "${yellow}removed source code from ros/src ..."

echo "${yellow}setting up nginx configurations ..."
mkdir ~/.virtualenvs/dotbot/run
sudo mkdir /var/log/uwsgi
sudo touch /var/log/uwsgi/uwsgi-dotbot.log
sudo rm /etc/nginx/sites-available/default 
sudo wget -O /etc/nginx/sites-available/robot-manager https://raw.githubusercontent.com/dotbot-io/server_config/master/robot-manager
echo "${yellow}copied nginx file ..."
sudo wget -O /etc/supervisor/conf.d/uwsgi-dotbot.conf https://raw.githubusercontent.com/dotbot-io/server_config/master/uwsgi-dotbot.conf
echo "${yellow}copied supervisor config file ..."
sudo wget -O /etc/avahi/avahi-daemon.conf https://raw.githubusercontent.com/dotbot-io/server_config/master/avahi-daemon.conf
echo "${yellow}copied avahi config file ..."
sudo ln -s /etc/nginx/sites-available/robot-manager /etc/nginx/sites-enabled
sudo service supervisor restart
sudo service nginx restart 
deactivate

echo "${yellow}adding sources to bash start..."
cd ~
echo "export LC_ALL='en_US.UTF-8'" >> .profile
echo "source /usr/local/bin/virtualenvwrapper.sh" >> .bashrc
echo "source /opt/ros/kinetic/setup.bash" >> .bashrc
echo "source /home/vagrant/ros/dotbot_ws/devel/setup.bash" >> .bashrc

echo "${yellow}Done installation"

sudo apt-get clean
