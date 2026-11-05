#!/bin/bash

opc=10
fecha=$(date +"%Y-%m-%d")

function menu (){
    clear
    echo "========================================="
    echo "   Menú para la gestión de FirewallD     "
    echo "========================================="
    echo "1 - Verificar estado"
    echo "2 - Permitir HTTP y HTTPS"
    echo "3 - Bloquear una IP"
    echo "4 - Habilitar solicitudes de ping"
    echo "5 - Listar servicios permitidos"
    echo "6 - Bloquear dirección MAC"
    echo "7 - Agregar un servicio"
    echo "0 - Salir"
    echo "========================================="
}

function verificar_firewall(){
    clear
    echo "Estado de FirewallD"
    firewall-cmd --state
    read -p "Presione enter para continuar" pausa
}

function permitir_http_https(){
    clear
    echo "Permitiendo tráfico HTTP y HTTPS"
    firewall-cmd --permanent --add-service=http
    firewall-cmd --permanent --add-service=https
    firewall-cmd --reload
    echo ""
    read -p "Presione enter para continuar" pausa
}

function bloquear_ip(){
    clear
    echo "Bloquear una Dirección IP"
    read -p "Ingrese la dirección IP que desee bloquear (Ej. 192.168.1.50): " ip
    #firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.1.200" drop'
    firewall-cmd --permanent --add-rich-rule="rule family='ipv4' source address='$ip' drop"
    firewall-cmd --reload
    read -p "Presione enter para continuar" pausa
}

function habilitar_ping(){
    clear
    echo "Habilitar solicitudes de PING"
    firewall-cmd --permanent --add-rich-rule='rule protocol value="icmp" accept'
    firewall-cmd --reload
    echo "Solicitudes de Ping habilitadas."
    echo ""
    read -p "Presione enter para continuar" pausa
}

function listar_servicios(){
    clear
    echo "Este es el servicio que se permite en la zona actual."
    zona=$(firewall-cmd --get-default-zone)
    echo "Zona actual: $zona"
    echo "Los servicios que están habilitados son:"
    firewall-cmd --list-services
    echo ""
    read -p "Presione enter para oontinuar" pausa
}

function bloquear_mac(){
    clear
    echo "Bloquear una Dirección MAC"
    read -p "Ingrese la dirección MAC que desee bloquear (Ej. 00:1A:2B:3C:4D:5E): " mac
    firewall-cmd --permanent --add-rich-rule="rule source mac='$mac' drop"
    firewall-cmd --reload
    echo "Se bloqueó la dirección MAC: $mac exitosamente."
    read -p "Presione enter para continuar" pausa
}

function agregar_servicio(){
    clear
    echo "Agregar nuevo servicio a FirewallD "
    read -p "Ingrese el nombre del servicio (Ej. mysql, mariadb, dns): " servicio

    if [ -n "$servicio" ]; then
        if firewall-cmd --permanent --add-service=$servicio 2>/dev/null; then
            firewall-cmd --reload
            echo -e "OK - El servicio '$servicio' se agregó correctamente."
        else
            echo -e "ERROR - El servicio '$servicio' no es válido o no existe en FirewallD."
        fi
    else
        echo -e "ERROR - El nombre del servicio no puede estar vacío."
    fi
    echo ""
    read -p "Presione enter para continuar" pausa
}


while [ $opc -ne 0 ]
do
    menu
    read -p "Ingrese la opción: " opc

    case $opc in
        1) verificar_firewall ;;
        2) permitir_http_https ;;
        3) bloquear_ip ;;
        4) habilitar_ping ;;
        5) listar_servicios ;;
        6) bloquear_mac ;;
        7) agregar_servicio ;;
        0)
            echo "Ejecución finalizada."
        ;;
        *)
            echo "ERROR - Opción incorrecta. Por favor ingrese un número del 0 al 8."
            read -p "Presione enter para continuar." pausa
        ;;
    esac
done
