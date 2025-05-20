#!/bin/bash

apt update && apt install -y pure-ftpd expect

groupadd --gid 6262 ftpGroup
useradd -u 6262 -g ftpGroup -d /dev/null -s /bin/false ftpUser
mkdir /home/FTP
ln -s /etc/pure-ftpd/conf/PureDB /etc/pure-ftpd/auth/75purepdb
echo no > /etc/pure-ftpd/conf/PAMAuthentication
echo no > /etc/pure-ftpd/conf/UnixAuthentication
echo yes > /etc/pure-ftpd/conf/CreateHomeDir

cat User.csv | while read LOGIN MDP DIR IP
do
	./CreeUtilisateur.expect $LOGIN $MDP $DIR $IP
done
service pure-ftpd restart


