# Redes en KVM/QEMU con virt-manager en Fedora

Este README documenta la experiencia práctica de configurar **redes NAT y Bridge** en `virt-manager` sobre Fedora Linux, y cómo resolver problemas comunes que pueden impedir que una máquina virtual tenga acceso a Internet o a la red local.

---

## 📌 Introducción

Herramientas como VirtualBox o VMware Workstation suelen traer configuraciones de red listas, pero con KVM/QEMU y `virt-manager` es necesario comprender cómo funciona el **stack de redes de libvirt**.Aquí aprenderás:

* A verificar si KVM y libvirt están funcionando.
* A configurar y probar la red por defecto (`NAT`).
* A crear un `bridge` para conectar máquinas virtuales directamente a la red local.

---

## 🛠️ Verificaciones iniciales

1.**Comprobar que KVM está cargado:**

```
   lsmod | grep kvm
```

2.**Verificar que libvirtd esta activo:**

```
   sudo systemctl status libvirtd
```
3.**Ver redes activas en libvirt:**

```
   sudo virsh net-list --all
```

4.**Ver interfaces de red en el host:**
```
   ip a
```
## 🌐 Red NAT (default)
📖 Concepto

La red NAT crea un puente virtual (virbr0) con un rango privado (por defecto 192.168.122.x o 192.168.124.x).
Las VMs salen a Internet traduciendo direcciones a través del host.

``` markdown
+-----------+        +-----------+       +-------------+
|   VM      | <----> |  virbr0   | NAT   |   Internet  |
| 192.168.x |        | 192.168.1 | ----> |             |
+-----------+        +-----------+       +-------------+
```

1. Revisar el puente virbr0

``` bash
ip a show virbr0
```

2. Comprobar que la red default está activa

```bash
sudo virsh net-start default
sudo virsh net-autostart default
```

3. Verificar procesos de DHCP/DNS

``` bash
ps aux | grep dnsmasq | grep libvirt
```

4. Revisar reglas de NAT
``` bash
sudo iptables -t nat -L -n -v | grep 192.168.124
```

5. Configurar la VM

En virt-manager → NIC → Network source selecciona:
Virtual network 'default': NAT

6. Pruebas dentro de la VM

``` bash
ping -c 3 192.168.124.1   # gateway
ping -c 3 8.8.8.8         # internet
ping -c 3 google.com      # DNS
```

✅ Si esto funciona, ya tienes salida a Internet.

## 🔥 Problema común: firewall bloquea NAT

En Fedora, el firewalld puede bloquear el forwarding. Solución:
``` bash
sudo firewall-cmd --zone=libvirt --add-forward --permanent
sudo firewall-cmd --zone=libvirt --add-masquerade --permanent
sudo firewall-cmd --reload
```

Verifica:
``` bash
sudo firewall-cmd --list-all --zone=libvirt
```

Debe decir:
``` bash
forward: yes
masquerade: yes
```


## 🔗 Red Bridge (acceso directo a la LAN)
📖 Concepto

La red Bridge conecta la VM directamente a la red física.
La VM recibe IP del router de tu casa, igual que tu PC.

+-----------+           +---------+          +-------------+
|   VM      | <-------> |   br0   | <------> |   Router    |
| 192.168.x |           | Bridge  |          | 192.168.1.1 |
+-----------+           +---------+          +-------------+

1. Crear el bridge
sudo nmcli connection add type bridge ifname br0 con-name br0
sudo nmcli connection add type ethernet ifname enp0s31f6 master br0


Reemplaza enp0s31f6 por el nombre de tu tarjeta física.

2. Levantar el bridge
sudo nmcli connection up br0
sudo nmcli connection up bridge-slave-enp0s31f6

3. Solicitar IP por DHCP
sudo dhclient -v br0

4. Verificar
ip a show br0
ip route


Deberías ver una IP en el rango de tu router (ej. 192.168.100.x).

5. Configurar la VM

En virt-manager → NIC → Network source, selecciona:
Bridge br0

6. Pruebas dentro de la VM
ip a
ping -c 3 192.168.100.1   # router
ping -c 3 8.8.8.8         # internet

## 📝 Conclusión

Con NAT las VMs salen a Internet sin exponerse a la LAN.

Con Bridge las VMs se integran en la red local y reciben IP del router.

virt-manager + libvirt es una alternativa potente y libre frente a VirtualBox o VMware.