#!/bin/bash

cat /etc/network/interfaces > /etc/network/oldinterfaces


read -p "Voulez-vous configurer une IP fixe ? (o/n) : " reponse

if [[ "$reponse" == "o" ]]; then
    read -p "Entrez l'adresse IP : " address
    read -p "Entrez le masque : " netmask
    read -p "Entrez la passerelle : " gateway
    read -p "Entrez le DNS : " dns

    echo "
# Interface loopback
auto lo
iface lo inet loopback

# Configuration de l'interface réseau en IP statique
allow-hotplug enp0s3
iface enp0s3 inet static
    address $address
    netmask $netmask
    gateway $gateway
    dns-nameservers $dns" > /etc/network/interfaces

    systemctl restart networking

    echo "
***********************************************
Votre config est : ****************************
Adresse IP : $address
Masque : $netmask
Passerelle : $gateway
DNS : $dns
***********************************************
Test de la configuration sur www.google.fr : **
***********************************************"
ping -c 3 www.google.fr > /dev/null

if [[ $? -eq 0 ]]; then
	echo "
***********************************************
Configuration OK ! ****************************
***********************************************"
else
	echo "
***********************************************
Erreur dans la configuration... ***************
***********************************************
"
fi


else
    read -p "Voulez-vous configurer un DHCP ? (o/n) : " reponse2

    if [[ $reponse2 == "o" ]]; then
        echo "
# Interface loopback
auto lo
iface lo inet loopback

#DHCP
allow-hotplug enp0s3
iface enp0s3 inet dhcp" > /etc/network/interfaces

	systemctl restart networking

	echo "
***********************************************
Test de la configuration sur www.google.fr : **
***********************************************"
ping -c 3 www.google.fr > /dev/null

	if [[ $? -eq 0 ]]; then
		echo "
***********************************************
Configuration OK ! ****************************
***********************************************
***********************************************
Votre IP est :     ****************************
***********************************************

$(ip a | grep "dynamic enp0s3")

"
	else
		echo "
***********************************************
Erreur dans la configuration... ***************
***********************************************
"
	fi

    fi
fi

