#!/bin/sh
#Cách cài đặt VM Ubuntu Linux trên ESXi làm KMS Server

#build KMS Server
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install build-essential nano git net-tools -y
cd /opt/

# Download source KMS Server

git clone https://github.com/kebe7jun/linux-kms-server
#Tao user
useradd -s /usr/sbin/nologin -r -M vlmcsd
#Cai dat KMS Server
cd /opt/linux-kms-server/vlmcsd/
make

#copy /paste
nano /lib/systemd/system/vlmcsd.service
[Unit]
Description=vlmcsd KMS emulator service
After=network-online.target
Wants=network-online.target

[Service]
Type=forking
User=vlmcsd
ExecStart=/opt/linux-kms-server/vlmcsd/vlmcsd -l /var/log/vlmcsd

[Install]
WantedBy=multi-user.target

mkdir /var/log/lvmcsd
chown vlmcsd:vlmcsd /var/log/vlmcsd

#Start/stop service
systemctl start vlmcsd
systemctl stop vlmcsd

#open 1688
ufw allow 1688/tcp

#check ip
ifconfig

#	Active key cho KMS Client Product key:
#	https://docs.microsoft.com/en-us/windows-server/get-started/kms-client-activation-keys
# https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/jj612867(v=ws.11)?redirectedfrom=MSDN
#	Open Windows Client: cmd /admin
# slmgr /upk
# slmgr /ipk [KMS Client Product key]
# slmgr /skms IP_KMS_Server
# slmgr /ato
#
#	Active Office:
#	CD \Program Files\Microsoft Office\Office16     
# 	OR 
#	CD \ Program Files (x86)\Microsoft Office\Office16
#	cscript ospp.vbs /sethst:Your_IP_OR_HOSTNAME_URL
#	cscript	ospp.vbs /inpkey: xxxx-xxxx-xxxx-xxxx-xxxx
#	cscript ospp.vbs /act
#	cscript ospp.vbs /dstatusall
#
#
# 	[Học MCSA 2022] Hướng dẫn cài đặt KMS Server trên Linux
#	https://www.youtube.com/watch?v=STF0VVKZzHY
