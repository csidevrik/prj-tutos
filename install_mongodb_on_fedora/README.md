How to install mongodb on fedora 
------------------------------------------------
Pues este sitio sera util para poder describir el proceso de instalacion de fedora 
## INTRODUCCION
Este tutorial sirve para indicar que sigo para instalar mongodb en linux fedora
He seguido un tutorial propio de la informacion de fedora.


### Crear file repositorio  para mongodb
Crearemos un archivo para el repositorio de mongodb-org
```shell
sudo nano /etc/yum.repos.d/mongodb-org-4.4.repo
```


### Insertar el siguiente contenido en el archivvo
Insertar las siguientes lineas dentro del archivo mongodb-org-4.4.repo
```shell
[Mongodb]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/8/mongodb-org/4.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc
```
### Habilitar el servicio, iniciarlo y revisar su estado

```shell
 sudo systemctl enable mongod.service
 sudo systemctl start mongod.service
 sudo systemctl status mongod.service
```
### Verificar si existe algun proceso llamado mongo


```shell
sudo netstat -plunt | grep mongo
```

### Permitir acceso en el firewall

```shell
sudo firewall-cmd --permanent --add-service=mongodb --zone=FedoraWorkstation
sudo firewall-cmd --reload
```


## BIBLIOGRAFIA

[fedora developer](https://developer.fedoraproject.org/tech/database/mongodb/about.html)
