#!/bin/bash
 
# para mostrar los comandos que se van ejecutando
set -x

# nos movemos al directorio temporal para que funcione en todas las distribuciones linux
cd /tmp

# descargamos el codigo fuente de phmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.zip --output-document /tmp/pma.zip

# instalamos unzip
apt install unzip -y

# descomprimimos el archivo
unzip /tmp/pma.zip

# movemos el codigo fuente de phpmyadmin
mv /tmp/phpMyAdmin-5.2.0-all-languages /var/www/html/phpmyadmin

# borramos los temporales
rm - f /tmp/pma.zip

# importamos la base de datos
mysql -u root < /var/www/html/phpmyadmin/sql/create_tables.sql 

# 
cd ../sql
mysql -u root < create_user.sql

