#!/bin/bash



echo "
*************************************************************************************
*************************************************************************************
********************************Test de la config reseau sur www.google.fr***********
*************************************************************************************
*************************************************************************************
"
ping -c 3 www.google.fr > /dev/null

if [[ $? -eq 0 ]]; then
    echo "
*************************************************************************************
********************************Config reseau OK !***********************************
*************************************************************************************
"
else
    echo "
*************************************************************************************
********************************Erreur dans la config reseau*************************
*************************************************************************************
"
    exit 1
fi



echo "
*************************************************************************************
*************************************************************************************
********************************Desinstallation de Pure-ftpd*************************
*************************************************************************************
*************************************************************************************
"

apt purge -y pure-ftpd


echo "
*************************************************************************************
*************************************************************************************
********************************Installation de Pure-ftpd****************************
*************************************************************************************
*************************************************************************************
"


apt update -y > /dev/null

apt install -y pure-ftpd

useradd -d /home/ftp -m -s /bin/false ftp

read -p "Voulez-vous activer le mode anonyme ? (o/n) : " anonyme
if [[ $anonyme == "o" ]]; then
	echo "no" > /etc/pure-ftpd/conf/NoAnonymous
	read -p "L'autoriser a uploader ? (o/n) : " upload

	if [[ $upload == "n" ]]; then
		echo "yes" > /etc/pure-ftpd/conf/AnonymousCantUpload
	else
		echo "no" > /etc/pure-ftpd/conf/AnonymousCantUpload
	fi

	read -p "Activer la connexion anonyme seul ? (o/n) : " anonymeSeul
	if [[ $anonymeSeul == "o" ]]; then
		echo "yes" > /etc/pure-ftpd/conf/AnonymousOnly
	else
		echo "no" > /etc/pure-ftpd/conf/AnonymousOnly
	fi
fi

read -p "Restreindre l access a la zone de l'utilisateur ?  (o/n) : " zone
if [[ $zone == "o" ]]; then
	echo "yes" > /etc/pure-ftpd/conf/ChrootEveryone
else
	echo "no" > /etc/pure-ftpd/conf/ChrootEveryone
fi

read -p "Combien de clients maximum connecter voulez-vous ? : " clientsNumber
echo $clientsNumber > /etc/pure-ftpd/conf/MaxClientsNumber


read -p "Combien de clients maximum par IP voulez-vous ? : " clientsIP
echo $clientsIP > /etc/pure-ftpd/conf/MaxClientsPerIP


read -p "Sauvegarder tout les fichiers d eposees ? (o/n) : " keep
if [[ $keep == "o" ]]; then
	echo "yes" > /etc/pure-ftpd/conf/KeepAllFiles
else
	echo "no" > /etc/pure-ftpd/conf/KeepAllFiles
fi


read -p "Autoriser a renomer les fichiers ? (o/n) : " rename
if [[ $rename == "n" ]]; then
	echo "yes" > /etc/pure-ftpd/conf/NoRename
else
	echo "no" > /etc/pure-ftpd/conf/NoRename
fi


systemctl restart pure-ftpd

if [[ $? -eq 0 ]]; then
    echo "
*************************************************************************************
*************************************************************************************
********************************Installation reussite********************************
*************************************************************************************
*************************************************************************************
*************************************************************************************
Restriction de zone de l'utilisateur -- : $(cat /etc/pure-ftpd/conf/ChrootEveryone)
Nombre de clients Max connecter ------- : $clientsNumber
Nombre de clients Max par IP ---------- : $clientsIP
Sauvegarde des fichier 	--------------- : $(cat /etc/pure-ftpd/conf/KeepAllFiles)
Bloquer le renomage des fichiers ------ : $(cat /etc/pure-ftpd/conf/NoRename)
Bloquer le mode anonyme --------------- : $(cat /etc/pure-ftpd/conf/NoAnonymous)
*************************************************************************************
*************************************************************************************
"
else
    echo "
*************************************************************************************
*************************************************************************************
********************************Erreur lors de l'installation************************
*************************************************************************************
*************************************************************************************
"
fi

