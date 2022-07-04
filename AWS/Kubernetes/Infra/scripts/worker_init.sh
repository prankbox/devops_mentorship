sudo apt update -y
sudo apt upgrade -y
sudo apt remove multipath-tools -y
sudo hostnameclt set-hostname worker-"${count.index}"
sudo reboot