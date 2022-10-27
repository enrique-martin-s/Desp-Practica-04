#!/bin/bash
 
#para mostrar los comandos que se van ejecutando
set -x

# Actualizamos los repositiorios
apt update

# Actualizamos los paquetes
apt upgrade -y

# Instalacion del servidor web apache
apt install apache2 -y

# Instalamos el sistema gesto de bases de datos mysql
apt install mysql-server -y
 
# Instalamos php y los modulos necesarios
apt install php libapache2-mod-php php-mysql -y


