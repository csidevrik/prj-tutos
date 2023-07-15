Customizing fedora tratare de documentar como instalar fedora de la mejor manera
------------------------------------------------
Pues es que cuando instalo fedora tengo un problema al usarlo, porque siempre me toca instalar ciertas librerias que no vienen por defector 
## INTRODUCCION
Esta pagina trata de introducirnos a como esta organizada este repo de tutoriales. sera como el indice de los tutoriales, tratará de guiarnos para los siguientes tutoriales.


### Install utils
Previamentes, suelo instalar algunas applicaciones de cli, para el emjor uso del sistema en fedora y porque ya me he acostumbrado a utilizar cuando instalo linux.

#### Basics
Para el trabajo con la cli
```shell
sudo dnf install git curl zsh ncdu htop -y
```
#### Oh my zsh
Oh My Zsh is a delightful, open source, community-driven framework for managing your Zsh configuration. It comes bundled with thousands of helpful functions, helpers, plugins, themes, and a few things that make you shout...

[OH MY ZSH](https://ohmyz.sh/)

En nuestro caso lo ideal es que no nos pida la confirmacion de password del usuario pero como lo ven en fedora 38 al parecer ya no fue necesario, no si sea porque es maquina virtual, esto habrá que comprobarlo en una maquina fisica.


![Alt text](https://github.com/carlossiguam/prj-tutos/blob/main/install%20fedora%20and%20customizing/assets/Screenshot%20from%202023-07-12%2006-49-40_FED38_install%20ohmy%20zsh.png "Install oh my zsh")



### Install anydesk
Deberemos mencionar que en la version  37 de fedora, hemos tenido inconvenientes al instalar del paquete rpm de anydesk, esperamos que esto no pase en fedora 38, pero vamos a tratar de documentar lo que nos pase y saber como corregirlos.

[anydesk downloads linux](https://anydesk.com/en/downloads/linux)

Entonces seleccionamos o usamos el rpm repository 

[anydesk rpm repository](http://rpm.anydesk.com/howto.html)

Hay que convertirse en root para ejecutar las lineas para fedora, las lineas que se mencionan en la URL anterior

```shell
cat > /etc/yum.repos.d/AnyDesk-Fedora.repo << "EOF" 
[anydesk]
name=AnyDesk Fedora - stable
baseurl=http://rpm.anydesk.com/fedora/$basearch/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://keys.anydesk.com/repos/RPM-GPG-KEY
EOF
```

```shell
sudo dnf update
```

Luego de esto usamos


![Alt text](https://github.com/carlossiguam/prj-tutos/blob/main/install%20fedora%20and%20customizing/assets/install%20anydesk%20cli%20response.png "Install anydesk from cli")

Como podemos evidenciar no se instala anydesk porque falta algun repositorio que brinde la libreria libgtkglext-x11-1_0-0

Ahora tenemos que encontrar esta libreria descargarla e instalarla.

#### Method 1 removing libgtklgext from dependencies

En este foro [Pablo Two] nos sugiere instalar el paquete rpm de anydesk sin tomar en cuenta la dependencia de libgtkglext

Entonces primero tenemos que descargar la libreria de anydesk
Descargue su paquete desde aqui: [anydesk downloads](https://download.anydesk.com/linux/)


```shell
➜  wget http://mirror.centos.org/centos/7/os/x86_64/Packages/mesa-libGLU-devel-9.0.0-4.el7.x86_64.rpm
➜  sudo rpm -i mesa-libGLU-devel-9.0.0-4.el7.x86_64.rpm 
➜  sudo dnf install mesa-libGLU  
wget https://rpmfind.net/linux/opensuse/distribution/leap/15.4/repo/oss/x86_64/libgtkglext-x11-1_0-0-1.2.0git20110529-150400.12.8.x86_64.rpm
➜  sudo rpm -i libgtkglext-x11-1_0-0-1.2.0git20110529-150400.12.8.x86_64.rpm
➜  sudo rpm -i libgtkglext-x11-1_0-0-1.2.0git20110529-150400.12.8.x86_64.rpm
➜  wget https://download.anydesk.com/linux/anydesk_6.2.1-1_x86_64.rpm
➜  sudo rpm -i anydesk_6.2.1-1_x86_64.rpm 
```
