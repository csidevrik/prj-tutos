How to install zabbix on fedora 
------------------------------------------------
Pues este sitio sera util para poder describir el proceso de instalacion de zabbix sobre fedora.

## INTRODUCCION
Tratare de seguir varias guias hasta llegar a la guia definitiva para fedora, al parecer no existe la definitiva

## Instalar servidor web 
En nuestro caso estamos escogiendo nginx el preferido para mis despliegues

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
### Open the firewall for nginx

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



## BIBLIOGRAFIA

[tutorial para centOS](https://www.tecmint.com/install-and-configure-zabbix-monitoring-on-debian-centos-rhel/)
