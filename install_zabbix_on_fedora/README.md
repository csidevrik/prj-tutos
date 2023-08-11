How to install zabbix on fedora 38 
------------------------------------------------
Pues este sitio sera util para poder describir el proceso de instalacion de zabbix sobre fedora.



# 1 INTRODUCCION

Tratare de seguir varias guias hasta llegar a la guia definitiva para fedora, al parecer no existe la definitiva

---
# 2 INSTALL WEB SERVER
Estamos prefiriendo nginx para todo tipo de despliegue
```shell
sudo dnf -y install nginx
```

Enter y at the prompt to confirm that you want to install the package.

After the installation completes, run the following commands to enable and start
the service. These commands start Nginx and configure it to start up when the
server does.

```shell
sudo systemctl enable nginx
sudo systemctl start nginx
```
## 2.1 Open firewall port for nginx

```shell
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
```
Reload to apply new settings
```shell
sudo firewall-cmd --reload
```

Si todo salio bien, veremos la siguiente ventana en el navegador
![Alt text](nginxFedora.png)

## 2.2 Install php libraries
Como era de esperarse zabbix esta construido con php, por tanto hay que instalar las librerias necesarias para su ejecucion

```shell
sudo dnf install php-8.2.4-1.fc38.x86_64 php-mysqlnd-8.2.4-1.fc38.x86_64 php-ldap-8.2.4-1.fc38.x86_64 php-bcmath-8.2.4-1.fc38.x86_64 php-mbstring-8.2.4-1.fc38.x86_64 php-gd-8.2.4-1.fc38.x86_64 php-gd-8.2.4-1.fc38.x86_64 php-xml-8.2.4-1.fc38.x86_64
```
![Alt text](php-libraries.png)


## 2.3 Modificar el archivo php.ini


El archivo php.ini, contiene directivas para el uso de php al desplegarse la aplicacion en php, en esta caso zabbix
#### Se recomienda hacer un backup
```bash
sudo cp -p /etc/php.ini{,.bkp}
```

Para modificar el archivo `php.ini` se debe ingresar a este con un editor en este caso nvim

```bash
sudo nvim /etc/php.ini
```

Encontramos las siguientes lineas que debemos cambiar:

```text
post_max_size = 16M
upload_max_filesize = 2M
max_execution_time 300
max_input_time = 300
memory_limit 128M
session.auto_start = 0
mbstring.func_overload = 0
date.timezone = America/Guayaquil
```
---
# 3 Install Zabbix packages

Instalar zabbix, para instalar zabbix en fedora me estoy basando en rocky linux, mirenlo en la siguiente captura

![Alt text](zabbix-platform-chosed.png)

## 3.1 Install zabbix repository
```shell
sudo rpm -Uvh https://repo.zabbix.com/zabbix/6.0/rhel/9/x86_64/zabbix-release-6.0-4.el9.noarch.rpm
sudo dnf clean  all
```
## 3.2 Install zabbix server, frontend, agent
```shell
dnf install zabbix-server-mysql zabbix-web-mysql zabbix-nginx-conf zabbix-sql-scripts zabbix-selinux-policy zabbix-agent
```
~~~
sudo systemctl enable zabbix-server-mysql
sudo systemctl start zabbix-server-mysql
sudo systemctl status zabbix-server-mysql
~~~

Verificar que puedas levantar el servicio antes de la instalacion y configuracion de la base de datos, debe quedarte algo mas o menos asi.

![Alt text](zabbix-server-enabled.png)

---
# 4 Install Database
Como digimos vamos a instalar mariadb-server que es la version de community
```shell
sudo dnf install mariadb-server
```
Si todo va bien veremos los siguientes paquetes instalados
![Alt text](mariadbserverpackage.png)
>[optional]
>```shell
>sudo dnf install mariadb-server-3:10.5.18-1.fc38.x86_64 mariadb-3:10.5.18-1.fc38.x86_64 
>```
En el caso que hayas instalado los paquetes anteriores y no hayas iniciado el servicio de mariadb, pues es esto lo que te pasar[a]
![Alt text](mysql-secure-installationC.png)

## 4.1 Levantar el servicio de la base de datos
```shell
sudo systemctl enable mariadb.service 
sudo systemctl start mariadb.service
sudo systemctl status mariadb.service
```
## 4.2 Asegurando Mariadb

```shell
sudo mysql_secure_installation       
```
Trata de ponerle asi como estamos indicando a continuacion
>NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!
>
>In order to log into MariaDB to secure it, we'll need the current
>password for the root user. If you've just installed MariaDB, and
>haven't set the root password yet, you should just press enter here.
>
>Enter current password for root (enter for none): 
>OK, successfully used password, moving on...
>
>Setting the root password or using the unix_socket ensures that nobody
>can log into the MariaDB root user without the proper authorisation.
>
>You already have your root account protected, so you can safely answer 'n'.
>
>>Switch to unix_socket authentication [Y/n] **n**
> ... skipping.
>
>You already have your root account protected, so you can safely answer 'n'.
>
>>Change the root password? [Y/n] **n**
> ... skipping.
>
>By default, a MariaDB installation has an anonymous user, allowing anyone
>to log into MariaDB without having to have a user account created for
>them.  This is intended only for testing, and to make the installation
>go a bit smoother.  You should remove them before moving into a
>production environment.
>
>>Remove anonymous users? [Y/n] **Y**
> ... Success!
>
>Normally, root should only be allowed to connect from 'localhost'.  This
>ensures that someone cannot guess at the root password from the network.
>
>>Disallow root login remotely? [Y/n] **Y**
> ... Success!
>
>By default, MariaDB comes with a database named 'test' that anyone can
>access.  This is also intended only for testing, and should be removed
>before moving into a production environment.
>
>>Remove test database and access to it? [Y/n] **Y**
> - Dropping test database...
> ... Success!
> - Removing privileges on test database...
> ... Success!
>
>Reloading the privilege tables will ensure that all changes made so far
>will take effect immediately.
>
>>Reload privilege tables now? [Y/n] **Y**
> ... Success!
>
>Cleaning up...
>
>All done!  If you've completed all of the above steps, your MariaDB
>installation should now be secure.
>
>Thanks for using MariaDB!

![Alt text](mysqlenableservice.png)

>Change the root password


## 4.3 Create initial database
```shell
sudo mysql -uroot -p
password
MariaDB [(none)]> create database zabbix character set utf8mb4 collate utf8mb4_bin;
MariaDB [(none)]> create user zabbix@localhost identified by 'password';
MariaDB [(none)]> grant all privileges on zabbix.* to zabbix@localhost;
MariaDB [(none)]> set global log_bin_trust_function_creators = 1;
MariaDB [(none)]> quit;
```

## 4.4 Import Initital schema and data
```shell
sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix
```

```shell
MariaDB [(none)]> set global log_bin_trust_function_creators = 0;
MariaDB [(none)]> quit;
```

# 5 CONFIGURE DATABASE for service zabbix-server-mysql

```shell
➜  ~ sudo nvim /etc/zabbix_server.conf
```

![Alt text](zabbix-server-configurationDB.png)

Verifica la siguiente informacion en el archivo mencionado anteriormente, descomentala si es necesario.

>DBHost=localhost
>DBPort=3306
>DBUser=zabbix
>DBPassword=<PASSWORD>#
>DBSocket=/var/run/mysqld/mysqld.sock
>DBName=zabbix

# 6 CONFIGURE ZABBIX FOR LA WEB
```shell
sudo firewall-cmd --permanent --add-service=mysql --zone=FedoraServer
sudo firewall-cmd --permanent --add-port=8080/tcp --zone=FedoraServer
```

```shell
sudo reboot
```
><IP>/setup.php

Al final te tiene que resultar algo asi
![Alt text](zabbix-install-gui.png)

[Zabbix configuration](https://www.youtube.com/watch?v=CRumbty3gpI)


## BIBLIOGRAFIA

[tutorial para centOS](https://www.tecmint.com/install-and-configure-zabbix-monitoring-on-debian-centos-rhel/)

[documentation official zabbix database](https://www.zabbix.com/documentation/6.4/en/manual/appendix/install/db_scripts)

[zabbix packages](https://www.zabbix.com/download?zabbix=6.4&os_distribution=red_hat_enterprise_linux&os_version=9&components=server_frontend_agent&db=mysql&ws=apache)

