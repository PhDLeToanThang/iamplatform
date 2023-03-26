#!/bin/bash
clear
cd ~
#Step 1. First, we will install Heimdall 2.2.2 dashboard from its GitHub repo:
cd /opt
RELEASE=$(curl -sX GET "https://api.github.com/repos/linuxserver/Heimdall/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]'); echo $RELEASE &&\
curl --silent -o ${RELEASE}.tar.gz -L "https://github.com/linuxserver/Heimdall/archive/${RELEASE}.tar.gz"

tar xvzf Heimdall-*.tar.gz

#Step 2. Install PHP modules on Ubuntu 20.04:
# Next, because Heimdall is written in PHP and more specifically, the Laravel PHP web framework, 
# we will need to install 2 PHP module dependencies php-sqlite3 and php-zip on Ubuntu 20.04 in order to install Heimdall
sudo apt install php-sqlite3 php-zip

#Step 3 — Run Heimdall Dashboard with php artisan serve:
# Now change to the directory by cd Heimdall*/, which is your Heimdall installation, and try to start serving it with php artisan serve, 
#which is indeed the way to start any Laravel application. 
#You might see the following error because it’s not yet compatible with PHP 7.4 on Ubuntu 20.04.
#To fix it, edit the ArrayInput.php at line 135 with vim ./vendor/symfony/console/Input/ArrayInput.php +135 and comment on the elseif line and what’s inside. 
#The following screenshot shows the 2 lines of file: /ArrayInput.php 135,13 66%.
	#);
	# //} elseif ('-' === $key[0] {
	#// $this->addShortOption(substr($key,1), $value);
	#} else {

# Now run php artisan serve twice (at least for me) to see Laravel development server has started.
sudo php artisan SERVE
#Laravel development server started: <http://127.0.0.1:8000>
#Right-click “http://127.0.0.1:8000/” and open it, you should see portal dashboard running on your Ubuntu 20.04 OS like the following screenshot. 
#It says “There are currently no pinned applications, Add an application here or Pin an item to the dash”.
#Let’s add an entry to see if it works. To see it on the homepage, i.e., pinned, 
#make sure to click “PINNED” on the top right before you hit the “Save” button.
#As seen below, we successfully added LGTM.cf website to homepage!
	
#Step 4 — Auto-start portal using systemd service
#We are almost done, except we want it to start automatically after we install portal when Ubuntu 20.04 reboots even after an power outage.
#We will use systemd to to auto start portal dashboard when the OS boots. 
#Add the file portal.service in /etc/systemd/system/.
#sudo nano /etc/systemd/system/portal.service

#Add the following content to the file. Make sure you change the user, group, and WorkingDirectory as yours. 
#I also used an uncommon port 7889, you might want to change it if you want. 
#If you access portal from another computer, add --host 0.0.0.0 after 7889.

echo '[Unit]' >> /etc/systemd/system/portal.service
echo 'Description=portal' >> /etc/systemd/system/portal.service
echo 'After=network.target' >> /etc/systemd/system/portal.service
echo '[Service]' >> /etc/systemd/system/portal.service
echo 'Restart=always' >> /etc/systemd/system/portal.service
echo 'RestartSec=5' >> /etc/systemd/system/portal.service
echo 'Type=simple' >> /etc/systemd/system/portal.service
echo 'User=lgtm' >> /etc/systemd/system/portal.service
echo 'Group=lgtm' >> /etc/systemd/system/portal.service
echo 'WorkingDirectory=/home/lgtm/Heimdall-2.2.2' >> /etc/systemd/system/portal.service
echo 'ExecStart="/usr/bin/php" artisan serve --port 7889' >> /etc/systemd/system/portal.service
echo 'TimeoutStopSec=30' >> /etc/systemd/system/portal.service
echo '[Install]' >> /etc/systemd/system/portal.service
echo 'WantedBy=multi-user.target' >> /etc/systemd/system/portal.service
#Save and close the file. 

#To enable the service now, run the following command:
sudo systemctl enable --now portal.service

#Now open your browser and enter http://127.0.0.1:7889/. You should see the same interface as seen before. 
#Now if you reboot your computer or server, you should still be able to visit the URL. 
#If you added --host 0.0.0.0 before, you’ll need to find and type the IP of your computer instead of 127.0.0.1:7889. 
#You can usually find the IP address in your WiFi/wired network properties or with ifconfig. 
# Before we conclude, you might be wondering why not use php-fpm with Apache or Nginx. 
#The reason is that if you are the only user of Heimdall, the current setup will be fine (Thinks of you as the developer). 
#The complexity of using these web servers outweighs the gain of high-performance. 

