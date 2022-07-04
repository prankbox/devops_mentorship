sudo apt update -y
sudo apt full-upgrade -y --auto-remove
sudo apt remove multipath-tools -y
sudo hostnameclt set-hostname worker-"${count.index}"
sudo reboot now