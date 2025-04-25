#!/bin/bash

apt update
apt install net-tools
clear
choice=19
#Choice of Installation
while [ $choice -ne 5 ]
do
	echo ""
	echo " 1) - apache2 Servers, DataBase, Secure Configuration"
	echo " 2) - openssh-server + Secure Configuration ( To Allow SSH Connection ( Already Comes With Ftpd By Default)"
	echo " 3) - Pure-Ftpd (To Transfer Files)"
	echo " 4) - Show Open Ports"
	echo " 5) - Exit"
	read -p " You choose : " choice
	clear
	echo ""
	#An Other Choice
	case $choice in
	1)
		echo ""
		echo " 1) - Basic Installation "
		echo " 2) - Download DokuWiki (Personal Wikipedia)"
		echo " 3) - Download Mediawiki (An other Personal Wiki But Better It It Seems"
		echo " 4) - Download GLPI (Like Active Directory But Free, Allow to Keep Track Of The Computers ands Network + Tickets To Know What's Wrong)"
		echo " 5) - Download Wordpress (CMS, Used To Make Websites)"
		echo " 6) - Download Joomla (Just Like A Wordpress)"
		echo " 7) - Download Moodle (Mostly Used For Clasrooms)"
		echo " 8) - Download Dolibarr (Allow to Keep Track Of Sales,Buys,Clients,Sellers, ETC)"
		echo " 9) - Download "
		echo " 10) - See Connections And Bans"
		echo " 11) - Exit"
		read -p "You Choose : " choice
		echo ""
		case $choice in
		1)
			#Updates And Basic Installations
			apt -y update
			apt -y install apache2
			apt -y install php
			apt -y install php-mysql
			apt -y install mariadb-server
			apt -y install cron
                        apt install -y whois
			#Creation of the config and server
echo '<VirtualHost *:80>

        ServerName www.Server.com
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

<Directory /var/www/>
	Options Indexes FollowSymLinks
        AllowOverride None
        AuthName Connexion_Panel
        AuthType Basic
        AuthUserFile /etc/apache2/user.passwords
        Require valid-user
</Directory>

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>' > /etc/apache2/sites-available/New.conf

                        #Creation Of The Users
                        user="abc"
                        while [ "$user" != "n" ]
                        do
                                read -p "Enter The Name Of A User For The Server : " user
                                read -p " Enter The Password Of The User : " password
                                echo ""
                                echo $user:$(mkpasswd $password) >> /etc/apache2/user.passwords
				read -p "Do You Want An Other User ? (y/n) : " user
                        done

                        #Making Sure Only Apache2 And Root Can Check The Passwords
                        sudo chown www-data:www-data /etc/apache2/user.passwords
                        sudo chmod 640 /etc/apache2/user.passwords

			#Disable The Default Config
                        sudo a2dissite 000-default.conf

                        #Activate The Config That We Just Created
                        sudo a2ensite New.conf

			#Install Fail2Ban And Setup Auto Security + Auto Crontab Server Updates
			echo "59 23 * * * root apt -y update" >> /etc/crontab
			# je sais pas pourquoi le fail2ban bug, a voir
			#apt -y install fail2ban
			#cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.d/new_default.conf
			#sed -i 's/bantime  = 10m/bantime  = 59m/' /etc/fail2ban/jail.d/new_default.conf
			#sed -i 's/findtime  = 10m/findtime  = 59m/' /etc/fail2ban/jail.d/new_default.conf

			#Download Wget To Configure Adminer
			apt -y install wget
			wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php
			mv ./adminer-4.8.1.php /var/www/html/adminer.php
			echo "CREATE USER 'adminerroot'@'localhost' IDENTIFIED BY 'adminerroot';" > admin_creation.sql
			echo "GRANT ALL PRIVILEGES ON *.* TO 'adminerroot'@'localhost' WITH GRANT OPTION;" >> admin_creation.sql
			echo "FLUSH PRIVILEGES;" >> admin_creation.sql
			echo "exit;" >> admin_creation.sql
			mysql < admin_creation.sql
			rm admin_creation.sql
			clear

			echo ""
			echo ""
			echo "Voulez Vous Ajouter Un Nouvel Utilisateur ?"
			read -p " O/n : " newinput
			while [ "$newinput" != "n" ]
			do
				read -p "Quel serra sont nom ? " nomuser
				echo ""
       				read -p "Quel Est Le Mot De Passe De $nomuser ? : " mdpuser
				echo ""
       				echo "CREATE USER '$nomuser'@'localhost' IDENTIFIED BY '$mdpuser';" > user_creation.sql
				echo "Veuillez saisir les privilèges de $nomuser , Veuillez respecter les Majuscules tel que SELECT , INSERT , ALL"
				read -p "ALL / Administrateur , SELECT / Selectioner Une Table Ou Colomne , INSERT / Ajouter Des Données : " permission
				echo ""
				echo "Saissisez sur quel Table , Puis Colomne  les Permission $permission de $nomuser prendront effet"
				read -p " *.* / Toutes Les Colomnes De Tous Les Tableaux, Sinon Tableau.Colomne : " tabcolonne
       				echo "GRANT PRIVILEGES $permission ON $tabcolonne TO '$nomuser'@'localhost' WITH GRANT OPTION;" >> user_creation.sql
      				echo "FLUSH;" >>  user_creation.sql
       				echo "EXIT;" >> user_creation.sql
				echo "	| User - $nomuser : $mdpuser | $permission -> $tabcolomne" >> user_login.txt
				echo "	| User - $nomuser : $mdpuser | $permission -> $tabcolomne" >> user_login_backup.txt
				mysql < user_creation.sql
				sleep 1
				rm user_creation.sql
				echo ""
				read -p "Voulez-vous ajouter un autre utilisateur ? (O/n) : " newinput
			done
			#Restart Of The Systems To Apply Configs
                        systemctl reload apache2
                        systemctl reload crontab
                        systemctl reload fail2ban
			sleep 1
			clear

			echo ""
			echo ""
			echo " 		*********************************************************************"
			echo " 		*----------------------- Installation complete ---------------------*"
			echo " 		*********************************************************************"
			echo ""
			echo " 		 ____________________________________________________________________ "
			echo " 		|                                                                    |"
			echo " 		|                         User Informations                          |"
			echo " 		|____________________________________________________________________|"
			echo " 		|                                                                    |"
			echo " 		|        - Login : adminerroot                                       |"
			echo " 		|        - Password : adminerroot                                    |"
			echo " 		|        - Database Panel : /adminer.php                             |"
			echo " 		|____________________________________________________________________|"
			echo ""
			echo ""
			echo " 		 ____________________________________________________________________"
			echo " 		|                                                                    |"
			echo " 		|                     Server System Information                      |"
			echo " 		|____________________________________________________________________|"
			echo " 		|                                                                    |"
			echo " 		| - Server : Apache 2.4.62 (Automatically Installs The New Version)  |"
			echo "		| - ServerName : www.Server.com (If Public)                          |"
			echo " 		| - Database : Adminer 4.8.1                                         |"
			echo " 		| - Fail2Ban : Automatically Bans For 1 Hour After 3 Tries           |"
			echo " 		| - CronTab : Automatically Updates The Server at 23:59 Local Time   |"
			echo " 		| - Index : Index.html replaced by index.php                         |"
			echo " 		| - phpinfo : Main Page Gives Further Details On Server Infos        |"
			echo " 		|____________________________________________________________________|"
			echo ""
			echo ""

			read -p "Voulez vous vérifier les utilisateurs présents ? O/n :" present
			if [ "$present" != "n" ]
			then
				echo ""
				cat user_login.txt
			else
				echo "vous avez choissis de ne pas voir les utilisateur présents"
			fi

		;;
		2)
			wget 'https://download.dokuwiki.org/out/dokuwiki-a6b3119b5d16cfdee29a855275c5759f.tgz'
			tar -xzvf dokuwiki*
			mv dokuwiki /var/www/html
			rm dokuwiki*
			chown -R www-data:www-data /var/www/html/dokuwiki
			echo ""
			echo " Find the Dokuwiki at 127.0.0.1/dokuwiki"
			echo ""
		;;
		3)
			#mediawiki
			sudo apt install php php-common php-mysql php-cli php-json php-opcache php-gd php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip
			mysql_secure_installation
			echo "CREATE DATABASE mediawiki_db;" > admin_creation.sql
                        echo "CREATE USER 'mediawikiadmindb'@'localhost' IDENTIFIED BY 'WikiW1k1Wh@t!!';" >> admin_creation.sql
                        echo "GRANT ALL PRIVILEGES ON mediawiki_db.* TO 'mediawikiadmindb'@'localhost' WITH GRANT OPTION;" >> admin_creation.sql
                        echo "FLUSH PRIVILEGES;" >> admin_creation.sql
                        mysql < admin_creation.sql
                        rm admin_creation.sql
			sudo wget -O mediawiki.tar.gz https://releases.wikimedia.org/mediawiki/1.35/mediawiki-1.35.1.tar.gz
			sudo tar xzvf mediawiki.tar.gz --directory /var/www/html
			sudo mv /var/www/html/mediawiki* /var/www/html/wiki
			systemctl restart apache2
			echo ""
			echo 'Credentials of The MediaWiki DB : db = mediawiki_db , mediawikiadmindb:WikiW1k1Wh@t!!'
			echo ""
			localcp="aze"
			while [ "$localcp" != "cp" ]
			do
				read -p "Please Enter 'cp' When You Have Downloadeds Your LocalSettings.php : " localcp
			done
			sudo mv ~/Downloads/LocalSettings.php /var/www/html/wiki 2> /dev/null
			if [ $? -ne 0 ]
			then
				sudo mv ~/Téléchargements/LocalSettings.php /var/www/html/wiki
			else
				echo "Error, The Moove Of The LocalSettings.php Is Wrong, Please Do [sudo mv ~/Download_Directory/LocalSettings.php /var/www/html/wiki] "
			fi
			echo ""
			echo "Installation Complete ! "
		;;
		4)
			echo "CREATE DATABASE glpi_db;" > admin_creation.sql
			echo "CREATE USER 'glpiadmindb'@'localhost' IDENTIFIED BY 'glpiadmindb';" >> admin_creation.sql
			echo "GRANT ALL PRIVILEGES ON glpi_db.* TO 'glpiadmindb'@'localhost' WITH GRANT OPTION;" >> admin_creation.sql
			echo "FLUSH PRIVILEGES;" >> admin_creation.sql
			mysql < admin_creation.sql
			rm admin_creation.sql
			wget 'https://github.com/glpi-project/glpi/releases/download/10.0.17/glpi-10.0.17.tgz'
			tar -xzvf glpi*
			mv glpi /var/www/html
			rm glpi*
			apt -y install php-mbstring
                        apt -y install php-bz2
                        apt -y install php-zip
                        apt -y install php-ldap
                        apt -y install php-curl
                        apt -y install php-gd
                        apt -y install php-intl
                        apt -y install php-xml
			chown -R www-data:www-data /var/www/html/glpi
			systemctl restart apache2
			systemctl restart mariadb.service
			i=120
			echo ""
			echo "Installation Complete, Please Check 127.0.0.1/glpi In Your Browser To Continue"
			echo " Credentials to connect to the DB = glpi_db ,  glpiadmindb:glpiadmindb"
			echo ""
			while [[ $i -gt 0 ]]; do
				echo -ne "\r For Security Reasons The File /glpi/install/install.php Will Be Deleted In : $i Seconds"
				sleep 1
				((i--))
			done
			echo ""
			echo ""
			sudo rm -f /var/www/html/glpi/install/install.php
			echo "/glpi/install/install.php Deleted Succesfully"
		;;
		5)
			#wordpress
			apt -y install curl
			apt -y install php-curl
			apt -y install php-gd
			apt -y install php-mbstring
			apt -y install php-xml
			apt -y install php-xmlrpc
			apt -y install php-soap
			apt -y install php-intl
			apt -y install php-zip
			sudo mysql_secure_installation
			echo "CREATE DATABASE wp_basicdb DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" > admin_creation.sql
                        echo "CREATE USER 'wpadmindb'@'localhost' IDENTIFIED BY 'W0rdPr3ss!!';" >> admin_creation.sql
                        echo "GRANT ALL PRIVILEGES ON wp_basicdb.* TO 'wpadmindb'@'localhost' WITH GRANT OPTION;" >> admin_creation.sql
                        echo "FLUSH PRIVILEGES;" >> admin_creation.sql
                        mysql < admin_creation.sql
                        rm admin_creation.sql
			sudo wget 'https://wordpress.org/latest.tar.gz'
			sudo mkdir /var/www/wordpress
			sudo tar -xzvf latest.tar.gz --directory /var/www
			rm latest.tar.gz
			echo 'Alias /wordpress "/var/www/wordpress/"' > /etc/apache2/sites-available/wordpress.conf
			echo '<Directory /var/www/wordpress/>' >> /etc/apache2/sites-available/wordpress.conf
			echo -e "\t AllowOverride All" >> /etc/apache2/sites-available/wordpress.conf
			echo '</Directory>' >> /etc/apache2/sites-available/wordpress.conf
			sudo a2ensite wordpress.conf
			sudo a2dissite 000-default.conf
			sudo a2enmod rewrite
			sudo touch /var/www/wordpress/.htaccess
			sudo cp /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php
			sudo mkdir /var/www/wordpress/wp-content/upgrade
			sudo chown -R www-data:www-data /var/www/wordpress
			sudo find /var/www/wordpress/ -type d -exec chmod 750 {} \;
			sudo find /var/www/wordpress/ -type f -exec chmod 640 {} \;
			sed -i 's/database_name_here/wp_basicdb/' /var/www/wordpress/wp-config.php
			sed -i 's/username_here/wpadmindb/' /var/www/wordpress/wp-config.php
			sed -i 's/password_here/W0rdPr3ss!!/' /var/www/wordpress/wp-config.php
			echo ""
			curl -s https://api.wordpress.org/secret-key/1.1/salt/
			echo ""
			echo "define('FS_METHOD', 'direct');"
			echo ""
			echo "Copy Paste The Apis in the /var/www/wordpress/wp-config.php folder after Comenting The Already Existing Ones"
			echo ""
			echo " Path 127.0.0.1/wordpress"
			echo " DB : wp_basicdb , wpadmindb:W0rdPr3ss!!"
		;;
		6)
			sudo apt install php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip
                        mysql_secure_installation
                        echo "CREATE DATABASE Joomla_db DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" > admin_creation.sql
                        echo "CREATE USER 'joomlaadmindb'@'localhost' IDENTIFIED BY 'J00ml4!!';" >> admin_creation.sql
                        echo "GRANT ALL PRIVILEGES ON Joomla_db.* TO 'joomlaadmindb'@'localhost' WITH GRANT OPTION;" >> admin_creation.sql
                        echo "FLUSH PRIVILEGES;" >> admin_creation.sql
                        mysql < admin_creation.sql
                        rm admin_creation.sql
			sudo wget -O joomla.tar.gz https://downloads.joomla.org/cms/joomla3/3-9-24/Joomla_3-9-24-Stable-Full_Package.tar.gz?format=gz
                        sudo mkdir /var/www/joomla
                        sudo tar xzvf joomla.tar.gz --directory /var/www/joomla
                        echo 'Alias /joomla "/var/www/joomla/"' > /etc/apache2/sites-available/joomla.conf
                        echo '<Directory /var/www/joomla/>' >> /etc/apache2/sites-available/joomla.conf
                        echo "AllowOverride All" >> /etc/apache2/sites-available/joomla.conf
                        echo "</Directory>" >> /etc/apache2/sites-available/joomla.conf
                        sudo a2ensite joomla
                        sudo a2enmod rewrite
                        sudo chown -R www-data:www-data /var/www/joomla
                        sudo systemctl restart apache2
			i=120
			echo " Path : 127.0.0.1/joomla"
			echo " DB : Joomla_db , joomlaadmindb:J00ml4!!"

		;;
		7)
			apt -y install php-mysqli php-gd php-xmlrpc php-intl php-mbstring php-soap php-xml php-zip php-curl php-json libapache2-mod-php
			mysql_secure_installation
			echo "CREATE DATABASE Moodle_db DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" > admin_creation.sql
                        echo "CREATE USER 'moodleadmindb'@'localhost' IDENTIFIED BY 'M00DL3!!';" >> admin_creation.sql
                        echo "GRANT ALL PRIVILEGES ON Moodle_db.* TO 'moodleadmindb'@'localhost' WITH GRANT OPTION;" >> admin_creation.sql
                        echo "FLUSH PRIVILEGES;" >> admin_creation.sql
                        mysql < admin_creation.sql
                        rm admin_creation.sql
			cd /var/www/html
			sudo wget https://download.moodle.org/download.php/direct/stable405/moodle-latest-405.tgz
			sudo tar -zxvf moodle*
			sudo rm moodle-latest-405.tgz
			sudo chown -R www-data:www-data /var/www/html/moodle
			mkdir /var/www/moodledata
			sudo chown -R www-data:www-data /var/www/moodledata
echo '<VirtualHost *:80>' > /etc/apache2/sites-available/moodle.conf
echo 'ServerAdmin webmaster@localhost' >> /etc/apache2/sites-available/moodle.conf
echo 'DocumentRoot /var/www/html/moodle' >> /etc/apache2/sites-available/moodle.conf
echo ""  >> /etc/apache2/sites-available/moodle.conf
echo '<Directory /var/www/html/moodle>' >> /etc/apache2/sites-available/moodle.conf
echo -e "\t Options +Indexes +FollowSymLinks +MultiViews" >> /etc/apache2/sites-available/moodle.conf
echo -e "\t AllowOverride All" >> /etc/apache2/sites-available/moodle.conf
echo -e "\t Require all granted" >> /etc/apache2/sites-available/moodle.conf
echo '</Directory>' >> /etc/apache2/sites-available/moodle.conf
echo "" >> /etc/apache2/sites-available/moodle.conf
echo 'ErrorLog ${APACHE_LOG_DIR}/error.log' >> /etc/apache2/sites-available/moodle.conf
echo 'CustomLog ${APACHE_LOG_DIR}/access.log combined' >> /etc/apache2/sites-available/moodle.conf
echo '</VirtualHost>' >> /etc/apache2/sites-available/moodle.conf
			sed -i 's/mysqli/mariadb/' /var/www/html/moodle/config.php
			sed -i 's/;max_input_vars = 1000/max_input_vars = 6000/' /etc/php/8.2/apache2/php.ini
			sudo a2ensite moodle.conf
			sudo a2enmod rewrite
			sudo systemctl restart apache2
			echo ""
			echo "Path : 127.0.0.1/moodle"
			echo " DB : Moodle_db , moodleadmindb:M00DL3!!"
		;;
		8)
			apt -y install curl nano wget unzip zip
			apt -y install php libapache2-mod-php php-cli php-intl php-json php-common php-mbstring php-imap php-mysql php-zip php-gd php-mbstring php-curl php-xml
			sed -i 's/memory_limit = 128M/memory_limit = 512M/' /etc/php/8.2/apache2/php.ini
			sed -i 's/post_max_size = 8M/post_max_size = 32M/' /etc/php/8.2/apache2/php.ini
			sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 32M/' /etc/php/8.2/apache2/php.ini
			sed -i 's/;date.timezone =/date.timezone = America/Chicago/' /etc/php/8.2/apache2/php.ini
			systemctl restart apache2
			mysql_secure_installation
                        echo "CREATE DATABASE dolibarr_db;" > admin_creation.sql
                        echo "CREATE USER 'dolibarradmindb'@'localhost' IDENTIFIED BY 'D0l1b4rn3WP4sSw04d';" >> admin_creation.sql
                        echo "GRANT ALL PRIVILEGES ON dolibarr_db.* TO 'dolibarradmindb'@'localhost' WITH GRANT OPTION;" >> admin_creation.sql
                        echo "FLUSH PRIVILEGES;" >> admin_creation.sql
                        mysql < admin_creation.sql
                        rm admin_creation.sql
			wget 'https://github.com/Dolibarr/dolibarr/archive/refs/tags/19.0.0.zip'
			unzip 19.0.0.zip -d /var/www/
			mkdir /var/www/dolibarr
			mv /var/www/dolibarr-19.0.0/htdocs/* /var/www/dolibarr
			chown -R www-data:www-data /var/www/dolibarr/
echo '<VirtualHost *:80>

        ServerName www.Server.com
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/dolibarr/

<Directory /var/www/dolibarr>
        Options +FollowSymLinks
        AllowOverride All
        AuthName Connexion_Panel
        AuthType Basic
        AuthUserFile /etc/apache2/user.passwords
        Require valid-user
</Directory>

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>' > /etc/apache2/sites-available/dolibarr.conf
			rm -r /etc/apache2/sites-available/New.conf
			a2ensite dolibarr.conf
			echo ""
			echo " Path : 127.0.0.1"
			echo " DB : dolibarr_db , dolibarradmindb:D0l1b4rn3WP4sSw04d"
		;;
		9)
		;;
		10)
			sudo fail2ban-client status sshd
		;;
		11)
			echo " Leaving . . . "
		;;
		*)
			echo " Error "
		;;
		esac
	;;
	2)
		apt update && apt install openssh-server
		sed 's/# Port 22/Port 2201/' /etc/ssh/sshd_config
		sed 's/# LoginGraceTime 2m/LoginGraceTime 15s/' /etc/ssh/sshd_config
		sed 's/# PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
		sed 's/# MaxAuthTries 6/MaxAuthTries 2/' /etc/ssh/sshd_config
		echo ""
		systemctl restart openssh
		read -p "do you want to put your ip address into static mode ? (y/n) : " choice
		echo ""
		case $choice in
		y)
			echo "put 'static' in the end of the iface line blow Primary network interface"
			echo "address	IP"
			echo "netmask	mask"
			echo "gateway	router_adress"
			echo "dns-server	8.8.8.8"
			echo " don't forget to reboot the machine"
		;;
		n)
			echo " Goodbye "
		;;
		*)
			echo " Error "
		;;
		esac
		echo ""
		echo ""
		echo "          *********************************************************************"
		echo "          *----------------------- Installation complete ---------------------*"
		echo "          *********************************************************************"
		echo ""
		echo '           ____________________________________________________________________ '
		echo '          |                                                                    |'
		echo "          |                         User Informations                          |"
		echo "          |____________________________________________________________________|"
		echo '          |                                                                    |'
		echo "          |        - Login : $USER                                             |"
		echo "          |        - Password : machine's user password                        |"
		echo "          |        - Configuration File : /etc/ssh/sshd_config                 |"
		echo "          |____________________________________________________________________|"
		echo ""
		echo ""
		echo "           ____________________________________________________________________"
		echo "          |                                                                    |"
		echo "          |                     Openssh Configuration                          |"
		echo "          |____________________________________________________________________|"
		echo "          |                                                                    |"
		echo "          | - Server : Openssh-server (Automatically Installs The New Version) |"
		echo "          | - MaxTries : Automatically Logout After 2 Tries                    |"
		echo "          | - PermitRootLogin : Automatically Set to No                        |"
		echo "          | - Connection : Port automaticly switched to 2201                   |"
		echo "          | - LoginGraceTime : Automaticly disconnects after 15s               |"
		echo "          |____________________________________________________________________|"
		echo ""
		echo ""
	;;
	3)
		echo ""
		echo "1) - Install Pure-Ftpd"
		echo "2) - Get Ftp Logs (Screenshot) "
		echo "3) - Get Ftp Logs (Live)"
		echo "4) - Change Max Simultaneous Users Connected"
		echo "5) - Change Max Ftpd-Server Storage"
		echo "6) - Watch Current Active Sessions"
		echo "7) - Set Max CPU Usage For FTP"
		echo "8) - KeepAllFiles (upload and file rules) (Recommended But Can Be Restrictive)"
		echo "9) - Create Virtual Secure User"
		echo "10) - Change Password of Virtual User"
		echo "11) - Change Upload/Download speed Of User"
		echo "12) - Delete Virtual Secure User"
		echo "13) - See Virtual User Informations"
		echo "14) - Auto Create Virtual Users With List"
		echo "15) - Exit"
		read -p " You Choose : " ftp_choice
		echo ""
		case $ftp_choice in
		1)
			apt install -y pure-ftpd
			echo yes > /etc/pure-ftpd/conf/ChrootEveryone
			groupadd --gid 6262 ftpGroup
			useradd -u 6262 -g ftpGroup -d /dev/null -s /bin/false ftpUser
			mkdir /home/FTP
			ln -s /etc/pure-ftpd/conf/PureDB /etc/pure-ftpd/auth/75puredb
			echo no > /etc/pure-ftpd/conf/PAMAuthentication
			echo no > /etc/pure-ftpd/conf/UnixAuthentication
			echo yes > /etc/pure-ftpd/conf/CreateHomeDir
			echo ""
			read -p "Please Enter The Name Of The First Virtual User : " vuser
			pure-pw useradd $vuser -u ftpUser -d /home/FTP/$vuser -m
			read -p "Do You Want To Allow Secured Anonymous Connexion ? (y/n) : " anonymous_log
			if [ "$anonymous_log" != "n" ]
			then
				useradd -d /home/ftp -m -s /bin/false ftp
				echo no > /etc/pure-ftpd/conf/NoAnonymous
				echo "yes" > /etc/pure-ftpd/conf/AnonymousCantUpload
			else
				echo " You Choose Not To Allow Secured Anonymous Connection "
			fi
			echo "
                                                                               
        @                                                               @       
         @@                                                          .@@        
         %@@@@                                                     @@@@         
          /@@@@@@                                               @@@@@@          
             @@@@@@@#                                       @@@@@@@@            
             @@  @@@@@@@@                               @@@@@@@@ @@@            
              @@@@@& @@@@@@@@        &@@@@          @@@@@@@* @@@@@@             
               @@@@@@@@@//@@@@@@@     @@@@@@    @@@@@@@ @@@@@@@@@               
                  @@@@@@@@@@@.@@@@/   @@@@@@  @@@@@@@@@@@@@@@@@                 
                   @@@@@@@@@@%%,@@@.%@@@@@@@@@@@@,%%@@@@@@@@@&                  
                      @@@@@@@#.@@@@@@@@@@@@@@@#@@@ #@@@@@@&                     
                            @@@@ @@@ @@@@@@@ @@@ @@@@                           
                          /@@@@ @@@@ @@@@@@  @@@@(@@@@                          
                            @@@ @@@ Ftpd-Server @@@@@                           
                              @ .@@@@  @@@  @@@@  @                             
                                 @@@@@  @  @@@@@                                
                               @@@/@ ,@   @% @@@@@                              
                           %@@@@ @@   @   @   @@ @@@@@                          
                               @@#   @/@ &@@    @@                              
                                   @@%@,@@@@@@                                  
                                @@@@ @@/@ @@ @@@@                               
                                   @@@ @@@ @@@                                  
                                       @@                                       

                                 Welcome $USER !
" > /home/ftp/.banner
		;;
		2)
			cat /var/log/auth.log
		;;
		3)
			tail -f /var/log/auth.log
		;;
		4)
			read -p "Enter Max Simultaneous Connection On FTPD Server : " client_number
			echo "$client_number" > /etc/pure-ftpd/conf/MaxClientsNumber
		;;
		5)
			echo ""
			df -m
			echo ""
			echo "Here is Your available storage (in Mo, 1000Mo = 1Go) look at /dev/sd[a-z][1-9]"
			read -p "Please Enter The % Of The Disk You Want To Dedicate To The Ftp-Server : " max_ftp_storage
			echo "$max_ftp_storage" > /etc/pure-ftpd/conf/MaxDiskUsage
		;;
		6)
			pure-ftpwho -v
		;;
		7)
			read -p "Please Enter The % Of The CPU You Want To Dedicate : " maxload
			echo "$maxload" > /etc/pure-ftpd/conf/MaxLoad
		;;
		8)
			echo " KeepAllFiles Allow users to see and upload files but not delete,modify or rename them if they are not empty"
			read -p " Allow KeepAllFiles ? (yes/no) important to respect the yes or no syntax" keepfiles
			echo "$keepfiles" > /etc/pure-ftpd/conf/KeepAllFiles
		;;
		9)
			read -p " Please Enter The Name Of The New User : " user
			pure-pw useradd $user -u ftpUser -d /home/FTP/$user -m
			systemctl restart pure-ftpd
		;;
		10)
			echo ""
                        cat /etc/pure-ftpd/pureftpd.passwd
                        echo ""
                        read -p "Select The User You Want To Change The Password Of : " userdel
                        pure-pw passwd $userdel -f /etc/pure-ftpd/pureftpd.passwd -F /etc/pure-ftpd/pureftpd.pdb
                ;;
		11)
			echo ""
                        cat /etc/pure-ftpd/pureftpd.passwd
                        echo ""
                        read -p "Select The User's Connexion You Want To Modify : " userdel
			echo "Do You Want To Change"
			echo "1) - Upload Connection"
			echo "2) - Download Connection"
			read -p "You Choose : " connectionchoice
			case $connectionchoice in
			1)
				read -p "Please Enter The Speed Of The Connection (in Ko, 1000 = 1Mo) : " speed
				pure-pw usermod $userdel -f /etc/pure-ftpd/pureftpd.passwd -F /etc/pure-ftpd/pureftpd.pdb -T $speed
			;;
			2)
				read -p "Please Enter The Speed Of The Connection (in Ko, 1000 = 1Mo) : " speed
				pure-pw usermod $userdel -f /etc/pure-ftpd/pureftpd.passwd -F /etc/pure-ftpd/pureftpd.pdb -t $speed
			;;
			esac
                ;;
		12)
			echo ""
			cat /etc/pure-ftpd/pureftpd.passwd
			echo ""
			read -p "Select The User You Want To Delete : " userdel
			pure-pw userdel $userdel -f /etc/pure-ftpd/pureftpd.passwd -F /etc/pure-ftpd/pureftpd.pdb
		;;
		13)
			echo ""
			cat /etc/pure-ftpd/pureftpd.passwd
			echo ""
			read -p "Select The User You Want Informations On : " userinfo
			echo ""
			pure-pw show $userinfo
		;;
		14)
			apt update && apt install expect
			#expect is used to automaticly do things it helps with scripts
			clear
			echo ""
			ls
			echo ""
			read -p " Please Enter The Name Of The List Of Users You Want to Create : " list
			echo '#!/usr/bin/expect' > createuserftpd.expect
			echo "" >> createuserftpd.expect
			echo 'set user [lindex $argv 0]' >> createuserftpd.expect
			echo 'set pass [lindex $argv 1]' >> createuserftpd.expect
			echo 'spawn pure-pw useradd $user -u ftpUser -d /home/FTP/$user -m' >> createuserftpd.expect
			echo 'expect "Password" {send "$pass\n"; sleep 2;}' >> createuserftpd.expect
			echo 'expect "Enter" {send "$pass\n"; sleep 2;}' >> createuserftpd.expect
			echo ""
			echo 'puts "\n -----| Virtual user Created ! $user : $pass\n"' >> createuserftpd.expect
			cat $list |while read login mdp
			do
				/usr/bin/expect createuserftpd.expect $login $mdp
			done
		;;
		esac
		systemctl restart pure-ftpd.service
	;;
	4)
		netstat -4 -atn |grep -w 21
	;;
	5)
		echo ""
		echo " Leaving . . . "
		echo ""
	;;
	*)
		echo " Error "
	;;
	esac
	echo ""
	systemctl restart apache2
        #systemctl restart crontab
        #systemctl restart fail2ban
	#systemctl restart mariadb.service
done
