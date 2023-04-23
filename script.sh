#!/bin/bash

function redMessage() {
	echo -e "\\033[31;1m${@}\033[0m"
}

function greenMessage() {
	echo -e "\\033[32;1m${@}\033[0m"
}

function dMessage() {
	echo -e "\\033[36;1m${@}\033[0m"
}

function yellowMessage() {
	echo -e "\\033[33;1m${@}\033[0m"
}



redMessage "Willkommen bei dem Night-Hosting Multiscript"
printf "\n\n"
sleep 2.0


# Abfrage, ob Teamspeak oder Minecraft installiert werden soll
# Auswahlmenü anzeigen




	greenMessage "#######################################################"
	echo " "
	echo ""
yellowMessage "                   Teamspeak Optionen"
 greenMessage "________________________________________________________" 
 echo ""
	dMessage "1) Teamspeak 3 Server installieren"
  dMessage "2) Teamspeak Server update"
	dMessage "3) Teamspeak Server starten"
	dMessage "4) Teamspeak Server stoppen"
 greenMessage "________________________________________________________" 
  echo ""
yellowMessage "                   Minecraft Optionen"
 greenMessage "________________________________________________________" 
  echo ""
  dMessage "5) Minecraft Server installieren"
  dMessage "6) Minecraft Server starten"
  dMessage "7) Minecraft Server stoppen"
  greenMessage "________________________________________________________" 
  echo ""
  yellowMessage "                 Webserver Optionen"
  greenMessage "________________________________________________________" 
  echo ""
  dMessage "8) PHPMyAdmin mit MariaDB"
  greenMessage "________________________________________________________" 
  echo ""
	redMessage "9) Abbrechen"
	echo ""
	echo " "
	greenMessage "#######################################################"
    read -p "Nummer: " option



### Installationsroutine für Teamspeak ###
if [ "$option" = "1" ]; then

greenMessage "Das Skript beginnt nun mit der Installation!"
sleep 1.0

  # Abhängigkeiten installieren
  sudo apt-get update
  sudo apt-get install -y wget bzip2

  # Teamspeak-Server herunterladen und entpacken
  wget https://download.night-hosting.de/teamspeak3-server_linux_amd64-3.13.7_.tar.bz2
  tar -xvjf teamspeak3-server_linux_amd64-3.13.7_.tar.bz2


  # Lizenz akzeptieren
  cd teamspeak3-server_linux_amd64
  echo "license_accepted=1" > .ts3server_license_accepted


  dMessage "Der Teamspeak Server wurde erfolgreich installiert!"
  yellowMessage "INFO: Um den Teamspeak Server zu starten, führe bitte erneut das Skript aus."

### Teamspeak Server update ###
elif [ "$option" = "2" ]; then

#Verzeichnis

cd /root/teamspeak3-server_linux_amd64/

wget https://files.teamspeak-services.com/releases/server/3.13.7/teamspeak3-server_linux_amd64-3.13.7.tar.bz2
tar -xjvf teamspeak3-server_linux_amd64-3.13.7.tar.bz2
chown -R ts3:ts3 /root/teamspeak3-server_linux_amd64/
cd teamspeak3-server_linux_amd64
su ts3
./ts3server_startscript.sh start


### Teamspeak Start ###
elif [ "$option" = "3" ]; then

# In das Teamspeak Verzeichnis gehen
cd /root/teamspeak3-server_linux_amd64

# Teamspeak Server starten
./ts3server_startscript.sh start

greenMessage "Der Teamspeak Server wurde erfolgreich gestartet!"

### Teamspeak Server stop ###
elif [ "$option" = "4" ]; then
# In das Teamspeak Verzeichnis gehen
cd /root/teamspeak3-server_linux_amd64

# Teamspeak Server starten
./ts3server_startscript.sh stop

greenMessage "Der Teamspeak Server wurde erfolgreich gestoppt!"


### Installiere Minecraft Server ###
elif [ "$option" = "5" ]; then

greenMessage "Das Skript beginnt nun mit der Installation!"
sleep 1.0


# Update
apt update
apt upgrade -y

# Screen
apt install screen -y

# Java
apt install default-jre -y

# Make a new directory in the home directory
mkdir minecraft
cd minecraft

# Download the Minecraft server software
wget https://download.getbukkit.org/spigot/spigot-1.19.3.jar
echo "eula = true" > eula.txt

# Create a script to run the Minecraft server
echo "#!/bin/bash
screen -AmdS minecraft java -Xms1024M -Xmx4096M -jar /root/minecraft/spigot-1.19.3.jar nogui" > run_server.sh

# Stop Skript

echo "#!/bin/bash
screen -r minecraft -X quit" > stop_server.sh

# Make the script executable
chmod +x run_server.sh
chmod +x stop_server.sh


greenMessage "Der Minecraft Server wurde erfolgreich installiert!"
yellowMessage "INFO: Um den Server zu starten führe bitte erneut das Skript aus."
yellowMessage "INFO: Die Server Datein findest du im root Ordner!"


### Minecraft Server start ###
elif [ "$option" = "6" ]; then

cd /root/minecraft

# Run the script to start the Minecraft server
./run_server.sh

greenMessage "Der Server wurde erfolgreich gestartet!"
yellowMessage "INFO: Um in die Konsole des Servers zu gelangen gebe screen -r ein."


### Minecraft Server stop ###
elif [ "$option" = "7" ]; then

cd /root/minecraft

# Stop Server
./stop_server.sh

greenMessage "Der Server wurde erfolgreich gestoppt!"


### PHPMYADMIN ###

elif [ "$option" = "8" ]; then

greenMessage "Das Skript beginnt nun mit der Installation!"
sleep 1.0

#Update
apt-get install pwgen -y
apt update && apt upgrade -y

#HauptPakete 
apt install ca-certificates apt-transport-https lsb-release gnupg curl nano unzip -y
wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
apt update
apt install apache2 -y
apt install php7.4 php7.4-cli php7.4-common php7.4-curl php7.4-gd php7.4-intl php7.4-json php7.4-mbstring php7.4-mysql php7.4-opcache php7.4-readline php7.4-xml php7.4-xsl php7.4-zip php7.4-bz2 libapache2-mod-php7.4 -y
apt install mariadb-server mariadb-client -y
#mysql_secure_installation
cd /usr/share
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip -O phpmyadmin.zip
unzip phpmyadmin.zip
rm phpmyadmin.zip
mv phpMyAdmin-*-all-languages phpmyadmin
chmod -R 0755 phpmyadmin

#Vhost Erstellen
echo -e '
Alias /phpmyadmin /usr/share/phpmyadmin

<Directory /usr/share/phpmyadmin>
    Options SymLinksIfOwnerMatch
    DirectoryIndex index.php
</Directory>
<Directory /usr/share/phpmyadmin/templates>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/libraries>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/setup/lib>
    Require all denied
</Directory>
' >> /etc/apache2/conf-available/phpmyadmin.conf

a2enconf phpmyadmin
systemctl reload apache2
mkdir /usr/share/phpmyadmin/tmp/
chown -R www-data:www-data /usr/share/phpmyadmin/tmp/

#MySQL Konfigurieren und User Erstellen
PASS=`pwgen -s 40 1`
mysql <<MYSQL_SCRIPT
CREATE USER 'admin'@'localhost' IDENTIFIED BY '$PASS';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
MYSQL_SCRIPT

ip=$(hostname -i)

#InstallationsLog / Zugangsdaten Erstellen
touch /root/phpmyadmin-data.txt
echo -e "######### PHPMYADMIN Zugang #########" >> /root/phpmyadmin-data.txt
echo -e "Link: http://"$ip"/phpmyadmin" >> /root/phpmyadmin-data.txt
echo -e "User: admin" >> /root/phpmyadmin-data.txt
echo -e "Passwort: $PASS" >> /root/phpmyadmin-data.txt

greenMessage "Die MySQL Datenbank wurde erfolgreich installiert!"
yellowMessage "INFO: Die Zugangsdaten findest du im root Ordner"





### Abbruch ###
elif [ "$option" = "9" ]; then

# Nachrichtausgabe

	echo "
     ##############################
    #        Vielen                 #
   #           Dank                #
   #            für die Nutzung   #
    #####  ################### #
        # #
       ##

"

    redMessage "Das Skript wurde erfolgreich beendet!"

    #Abbruch
          exit 



fi
