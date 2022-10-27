#!/bin/bash
 
#para mostrar los comandos que se van ejecutando
set -x

#nos movemos al directorio temporal para que funcione en todas las distribuciones linux
cd /tmp

#descargamos el codigo fuente de phmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.zip

#instalamos unzip
apt install unzip -y

