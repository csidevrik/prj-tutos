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
