#!/bin/bash
 
# para mostrar los comandos que se van ejecutando
set -x

# Paso 1: instalacion de phpmyadmin
# descargamos el codigo fuente de phmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.zip --output-document /tmp/pma.zip

# instalamos unzip
apt install unzip -y

# descomprimimos el archivo en /var/www/html
unzip /tmp/pma.zip -d /var/www/html

# renombramos el nombre del directorio
mv /var/www/html/phpMyAdmin-5.2.0-all-languages /var/www/html/phpmyadmin -y

# borramos los temporales
rm -f /tmp/pma.zip

# borramos la base de datos de phpmyadmin de instalaciones previas
mysql -u root <<< "DROP DATABASE IF EXISTS phpmyadmin;"

# importamos la base de datos
mysql -u root < /var/www/html/phpmyadmin/sql/create_tables.sql 

# Creamos el usuario de la base de datos phpmyadmin
mysql -u root < ../sql/create_user.sql


# Paso 2: instalacion de adminer
# creamos un directorio para adminer
mkdir -p /var/www/html/adminer
# descargamos el codigo fuente
wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql.php --output-document /var/www/html/adminer/index.php
