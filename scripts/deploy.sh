#!/bin/bash

set-x

# vamos a tmp (esta en todos los linux)
cd /tmp

#borramos el directorio de instalaciones anteriores
rm -rf iaw-practica-lamp

# descargamos el codigo de la aplicacion que queremos desplegar
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git

# Importamos el script de la base de datos
mysql -u root < /tmp/iaw-practica-lamp/db/database.sql


#movemos y limpiamos los archivos
mv /tmp/iaw-practica-lamp/src/* /var/www/html

rm /var/www/html/index.html

rm -rf /tmp/iaw-practica-lamp