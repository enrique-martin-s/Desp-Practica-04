# Desp-Practica-04

En esta práctica vamos a realizar la instalación de la pila LAMP en una instancia EC2 de AWS con Ubuntu Server y le añadiremos 
## Creación de una instancia en AWSr
Entramos a ``AWS`` con nuestras credenciales y clicamos en ``EC2`` (si no aparece podemos usar el buscador de arriba).
### Crear un par de claves
En el apartado ``Red y seguridad`` clicamos en ``Pares de claves`` y le damos a crear un par de claves. Le daremos un nombre y en nuestro caso seleccionaremos ``RSA`` y ``.pem``. Le daremos a crear y automaticamente nos pedirá guardar la clave privada en nuestro almacenamiento, así que la pondremos en un sitio seguro (y al alcance pues la usaremos más tarde).
### Crear un grupo de seguridad
Primero creamos nuestro grupo de seguridad para definir que puertos queremos abrir en nuestra instancia. Para ello, en el apartado ``Red y seguridad`` clicamos en ``Security groups``. Clicamos en crear un grupo de seguridad y escribimos el nombre para nuestro grupo y, si queremos, una descripción. Despues en reglas de entrada elegiremos los puertos que queremos abrir, que para este despliegue son los puertos TCP 80(http), 443(https), 22(ssh). Le damos a crear y listo.
### Crear una instancia
Después hacemos click en instancias y despues en ``lanzar instancia``. La rellenamos los datos de la instancia de la siguiente forma:
1. Escribimos el nombre para nuestra instancia.
2. Elegimos la imagen que vamos a utilizar, en este caso Ubuntu y seleccionamos la version ``Ubuntu 20.04``.
3. En tipo elegimos nuestro tamaño de cpu y memoria, en este caso ``t2.small`` o ``t2.medium``.
4. En par de claves seleccionamos nuestra clave previamente creada.
5. En grupos de seguridad elegimos el grupo que creamos antes.
6. Por último le damos a crear instancia.
7. Para poder asignar una ip elástica(por EC2-> Elastic compute cloud) a nuestra instancia, en el apartado  ``Red y seguridad`` clicamos en ``Direcciones IP elásticas`` y luego en ``asignar ip elástica``. Le damos a ``asignar`` con los parámetros por defecto, y una vez creada le damos a ``asociar esta IP elástica`` en la esquina superior derecha. En ``instancia`` elegimos la que acabamos de crear y le damos a ``asociar``. Listo, nuestra instancia ya tiene nuestra IP elástica asociada.

![629c9fed727f5cbff2e87ae4c4106bb7](https://user-images.githubusercontent.com/109650943/208253816-6a322fe4-f02c-454b-a77d-36a73ee166da.png)

## Despliegue de la pila LAMP
### Conexión a nuestra instancia
Nuestro primer paso será conectarnos a nuestra instancia recién creada por medio de ssh utilizando Visual Studio Code o cualquier otra alternativa a nuestra elección. Para ello:

1. Explicamos en el explorador remoto en el menú de la izquierda.

    ![Captura desde 2022-12-16 12-20-13](https://user-images.githubusercontent.com/109650943/208087565-065fef3b-35a8-4225-b707-75fc978bc79a.png)

2. Pinchamos en ``+`` en introducimos el siguiente comando:

    ``ssh -i "direccion donde se encuentra nuestro archivo .pem" ubuntu@nuestra ip elástica``

    En mi caso ``ssh -i "/home/ubuntu/vockey.pem" ubuntu@52.4.163.110``

3. Seleccionamos el archivo de configuración en el que guardar la configuración y listo.
4. La conexión aparecerá en el menú de la izquierda. Para conectarnos sera tan sencillo como seleccionarla y darle a la flecha ``->``

### Ejecución de los scripts
Una vez conectados, utilizaremos la consola de Ubuntu para descargar nuestros scripts copiando el repositorio. Para ello introduciremos el siguiente comando:
``git clone https://github.com/enrique-martin-s/Desp-Practica-04.git``

Una vez tengamos la carpeta de dicho repositorio, accederemos a ella con ``cd Desp-Practica-04/scripts`` y despúes ejecutaremos el script con ``sudo ./install_lamp.sh``.

Una vez terminada su ejecución, ya tendremos a nuestra disposición Apache, Mysql y PhP en nuestro Ubuntu server.

Despúes ejecutaremos el segundo script con ``sudo ./install_tools.sh``. Una vez termine podremos acceder a la ip de nuestra instancia y comprobar que disponemos de todas las herramientas (phpmyadmin, goaccess, adminer) visitando la direción ``"ip elástica"/"utilidad que queremos ver"``

## Explicacion de los scripts
### install_lamp.sh
1. El primer comando ``#!/bin/bash`` indica al terminal que debe usar bash para ejecutarlo.
2. ``set -x`` mostrará cada comando en el terminal antes de ejecutarlos.
3. ``apt update`` actualizará nuestros repositorios.
4. ``apt upgrade -y`` actualizará nuestros paquetes.
5. ``apt install apache2 -y`` instalará apache, y ``-y`` indica que acepte cualquier pregunta que haga durante la instalación
6. ``apt install mysql-server -y`` instalará Mysql
7. ``apt install php libapache2-mod-php php-mysql -y`` instalará php y los módulos necesarios para que funcione junto con mysql.
 
### install_tools.sh
1. El primer comando ``#!/bin/bash`` indica al terminal que debe usar bash para ejecutarlo.
2. ``set -x`` mostrará cada comando en el terminal antes de ejecutarlos.
3. Despues vienen definidas las variables de configuración. En concreto BLOWFISH_SECRET generará una clave hexadecimal con openssl necesaria para la codificacion de datos de phpmyadmin.
4. ``wget https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.zip --output-document /tmp/pma.zip`` descargará phpmyadmin y lo pondrá en la carpeta de archivos temporales, renombrandolo a pma.zip para facilidad de uso.
5. ``apt update`` actualizará nuestros repositorios.
6. ``apt install unzip -y`` instalará unzip, para poder descomprimir archivos.
7. ``unzip /tmp/pma.zip -d /var/www/html`` extraerá el archivo descargado a nuestro directorio raiz del web server.
8. ``rm -rf /var/www/html/phpMyAdmin-5.2.0-all-languages`` borrará la instalación anterior de phpmyadmin
9. ``mv /var/www/html/phpMyAdmin-5.2.0-all-languages /var/www/html/phpmyadmin`` renombrará la carpeta de los archivos extraidos.
10. ``cp /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php`` creamos el archivo de configuracion de phpmyadmin
11. ``sed -i "s/\['blowfish_secret'\] = '';/\['blowfish_secret'\] = '$BLOWFISH_SECRET';/" /var/www/html/phpmyadmin/config.inc.php`` lo editamos para incluir nuestra clave hexadecimal generada en el paso 3.
12. ``rm -f /tmp/pma.zip`` borramos el archivo compromido.
13. ``mysql -u root <<< "DROP DATABASE IF EXISTS phpmyadmin;"`` borra la base de datos de phpmyadmin anterior si existe
14. ``mysql -u root < /var/www/html/phpmyadmin/sql/create_tables.sql`` importa la base nueva
15. ``mysql -u root < ../sql/create_user.sql`` creamos el usuario. Podemos modificar los datos de este usuario en el archivo sql tambien adjunto con este repositorio.
16. ``apt install php-mbstring php-zip php-gd php-json php-curl -y`` instala los módulos de php necesarios para phpmyadmin.
17. ``systemctl restart apache2`` reiniciamos el servicio Apache
18. ``chown -R www-data:www-data /var/www/html/`` cambia el propietario y el grupo del directorio del servidor web
19. ``mkdir -p /var/www/html/adminer`` crea un directorio para adminer
20. ``wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql.php --output-document /var/www/html/adminer/index.php`` descarga el codigo fuente de adminer y lo mete en el directorio creado en el paso anterior renombrándolo a index.php.
21. ``apt install goaccess`` instala goaccess
22. ``mkdir -p /var/www/html/stats`` crea un directorio para las estadísticas de goaccess
23. ``goaccess /var/log/apache2/access.log -o /var/www/html/stats/index.html --log-format=COMBINED --real-time-html --daemonize`` indicamos que las estadísticas generen un archivo de salida index.html y que cambie en tiempo real. Además indicamos que este proceso debe ejecutarse en segundo plano. Para que esto funcione es necesario abrir el puerto 7890
24. ``mkdir -p /etc/apache2/claves`` creamos un directorio en apache con autenticación básica
25. ``htpasswd -cb /etc/apache2/claves/.htpasswd $STATS_USER $STATS_PASS`` creamos el archivo de contraseñas. Ahora nuestras estadísticas estaran protegidas por contraseña gracias a .htaccess.
