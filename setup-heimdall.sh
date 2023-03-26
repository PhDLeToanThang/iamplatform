#1. First, we will install Heimdall dashboard from its GitHub repo:
cd /opt
RELEASE=$(curl -sX GET "https://api.github.com/repos/linuxserver/Heimdall/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]'); echo $RELEASE &&\
curl --silent -o ${RELEASE}.tar.gz -L "https://github.com/linuxserver/Heimdall/archive/${RELEASE}.tar.gz"

tar xvzf 2.2.2.tar.gz

#2. Install PHP modules on Ubuntu 20.04:
# Next, because Heimdall is written in PHP and more specifically, the Laravel PHP web framework, 
# we will need to install 2 PHP module dependencies php-sqlite3 and php-zip on Ubuntu 20.04 in order to install Heimdall
sudo apt install php-sqlite3 php-zip

#3. Step 3 — Run Heimdall Dashboard with php artisan serve:
# Now change to the directory by cd Heimdall*/, which is your Heimdall installation, and try to start serving it with php artisan serve, 
#which is indeed the way to start any Laravel application. 
#You might see the following error because it’s not yet compatible with PHP 7.4 on Ubuntu 20.04.

