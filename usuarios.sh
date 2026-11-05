#!/bin/bash

opc=10
ano=$(date +%Y-%m-%d)

function menu(){
clear
echo"================================"
echo"<<Menu de gestion de usuarios>>"
echo"================================"
echo"1 - Agregar usuario"
echo"2 - Listar usuarios del sistema"
echo"3 - Buscar un usuario en el sistema"
echo"4 - Cambiar contraseña de usuario"
echo"5 - Borrar usuario"
echo"6 - Bloquear usuario"
echo"7 - Desbloquear usuario"
echo"0 - Salir"
}

function verificar_usuario() {
        nom="$1"
        if grep -q "^$nom:" /etc/passwd; then
                return 0
        else
                return 1
        fi
}

function agregar_usuario() {
        clear
        echo "Ingrese el apellido y nombre del usuario en formato: apellidonombre "
        read nombre
        usuario=$(echo $nombre | tr [:upper:] [:lower:])
        if verificar_usuario "$usuario"; then
                echo "El nombre del usuario ya está en uso"
                read pausa
        else
                echo "ingrese el grupo: "
                read grupo
                user_group=$(echo $grupo | tr [:upper:] [:lower:])
                grup=$(cat /etc/group | grep -c $user_group)
                if [ $grup -eq 1 ]; then
                        sudo useradd -g $user_group -c "$user_group $year" -d /home/usuario -m -s $usuario
                        sudo passwd -e -d $usuario
                        echo "usuario creado efectivamente"
                        echo "<< Presione enter para continuar >>"
                        read pausa
                else
                        echo "El grupo no existe"
                        echo "<< Presione enter para continuar >>"
                        read pausa
                fi
        fi
}

function listar_usuarios() {
        clear
        echo"================================="
        echo"<<    Usuarios del sistema:    >>"
        echo"================================="
        getent passwd | awk -F: '$3 >=1000 && $3 < 65534 {
                if ($7 == "/usr/sbin/nologin")
                        print $1, "Bloqueado"
                else
                print $1, "Normal"
}'
        echo "<< Presione enter para continuar >>"
        read pausa
}

function buscar_usuario() {
        clear
        echo "Ingrese el apellido y nombre del usuario en formato: apellidonombre "
        read nombre
        usuario=$(echo $nombre | tr [:upper:] [:lower:])
        if verificar_usuario "$usuario"; then
                echo "Usuaro encontrado"
                nom=$(cut -d ":" -f 1 /etc/passwd | grep $nombre)
                echo "Nombre: " $nom
                echo "<< Presione enter para continuar >>"
                read pausa
        else
                echo "Usuario no encontrado"
                echo "<< Presione enter para continuar >>"
                read pausa
        fi
}

function cambiar_contra() {
        clear
        echo "Ingrese el apellido y nombre del usuario en formato: apellidonombre "
        read nombre
        usuario=$(echo $nombre | tr [:upper:] [:lower:])
        if verificar_usuario "$usuario"; then
                sudo passwd $nombre
                echo "<< Presione enter para continuar >>"
                read pausa
        else
                echo "Usuario no encontrado"
                echo "<< Presione enter para continuar >>"
                read pausa
        fi
}

function eliminar_usuario() {
        clear
        echo "Ingrese el apellido y nombre del usuario en formato: apellidonombre "
        read nombre
        usuario=$(echo $nombre | tr [:upper:] [:lower:])
        if verificar_usuario "$usuario; then
                sudo deluser --remove-home $nombre
                echo "<< Presione enter para continuar >>"
                read pausa
        else
                echo "Ususario no encontrado"
                echo "<< Presione enter para continuar >>"
                read pausa
        fi
}

function bloquear_usuario() {
        clear
        echo "Ingrese el apellido y nombre del usuario en formato: apellidonombre "
        read nombre
        usuario=$(echo $nombre | tr [:upper:] [:lower:])
        if verificar_usuario "$usuario; then
                sudo usermod -s /usr/sbin/nologin $nombre
                sudo killall -u $nombre
                echo "<< Presione enter para continuar >>"
                read pausa
        else
                echo "Usuario no encontrado"
                echo "<< Presione enter para continuar >>"
                read pausa
        fi
}

function desbloquear_usuario() {
        clear
        echo "Ingrese el apellido y nombre del usuario en formato: apellidonombre "
        read nombre
        usuario=$(echo $nombre | tr [:upper:] [:lower:])
        if verificar_usuario "$usuario; then
                sudo usermod -s /bin/bash "$nombre"
                sudo killall
                echo "Usuario $nombre desbloqueado"
                echo "<< Presione enter para continuar >>"
                read pausa
        else
                echo "Usuario no encontrado"
                echo "<< Presione enter para continuar >>"
}

while [ $opc -ne 0 ]
do
        clear
        menu
        read -p "Ingrese una de las opciones: " op
        case $op in
        1)
          agregar_usuario ;;
        2)
          listar_usuarios ;;
        3)
          buscar_usuario ;;
        4)
          cambiar_contra ;;
        5)
          eliminar_usuario ;;
        6)
          bloquear_usuario ;;
        7)
          desbloquear_usuario ;;
        0)
          echo "Saliendo..."; break ;;
        *)
          echo "Opción no válida" ;;
        esac
done
