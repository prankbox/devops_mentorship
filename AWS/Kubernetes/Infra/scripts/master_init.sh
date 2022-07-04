#!/usr/bin/env bash
sudo apt update -y
sudo apt upgrade -y
sudo apt remove multipath-tools -y
sudo hostnameclt set-hostname master-"${count.index}"
sudo reboot