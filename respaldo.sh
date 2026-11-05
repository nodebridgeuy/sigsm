#!/bin/bash

# VARIABLES
opc=10
fecha=$(date +"%Y-%m-%d")

# Crear directorios necesarios en caso de que no existan
mkdir -p /root/respaldos_bd /root/respaldos_logs /root/logs_restaurados

# FUNCIONES
function menu(){
    clear
    echo "==============================================="
    echo "            GESTIÓN DE RESPALDOS               "
    echo "==============================================="
    echo "1 - Crear respaldo de Base de Datos"
    echo "2 - Crear respaldo de los Logs del sistema"
    echo "3 - Restaurar respaldo de Base de Datos"
    echo "4 - Restaurar respaldo de Logs del sistema"
    echo "5 - Eliminar respaldo"
    echo "6 - Listar respaldos disponibles"
    echo "7 - Configurar programación de respaldos"
    echo "8 - Enviar respaldo a ubicación remota"
    echo "0 - Salir"
    echo "==============================================="
}

function crear_respaldo_bd(){
    clear
    echo "--- Creando el respaldo de la Base de Datos ---"
    mysqldump -u root -p --databases sigsm --routines --triggers --events > "/root/respaldos_bd/${fecha}-sigsm_bd_backup.sql"
    echo "El respaldo de la Base de Datos ha sido creado exitosamente!!"
    read -p "Presione la tecla ENTER para continuar..." pausa
}

function crear_respaldo_logs(){
    clear
    echo "--- Creando los respaldos de los Logs del sistema ---"
    tar -czvf "/root/respaldos_logs/${fecha}-logs_sistema_backup.tar.gz" /var/log 2>/dev/null
    echo "El respaldo de los Logs ha sido creado exitosamente!!"
    read -p "Presione la tecla ENTER para continuar..." pausa
}

function restaurar_respaldo_bd(){
    clear
    echo "--- Restaurando los respaldos de la base de datos ---"
    clear
    echo "--- Creando los respaldos de los Logs del sistema ---"
    tar -czvf "/root/respaldos_logs/${fecha}-logs_sistema_backup.tar.gz" /var/log 2>/dev/null
    echo "El respaldo de los Logs ha sido creado exitosamente!!"
    read -p "Presione la tecla ENTER para continuar..." pausa
}

function restaurar_respaldo_bd(){
    clear
    echo "--- Restaurando los respaldos de la base de datos ---"
    echo "Respaldos de Base de Datos guardados en el sistema:"
    ls -l /root/respaldos_bd/*.sql 2>/dev/null || echo "No hay respaldos de Base de Datos"
    read -p "Ingrese el nombre del archivo a restaurar: " respaldo_bd
    if [ -f "/root/respaldos_bd/$respaldo_bd" ]; then
        mysql -u root -p < "/root/respaldos_bd/$respaldo_bd"
        echo "Respaldo de BD restaurado exitosamente."
    else
        echo "[ERROR] El archivo no existe."
    fi
    read -p "Presione ENTER para continuar..." pausa
}

function restaurar_respaldo_logs(){
    clear
    echo "--- Restaurando respaldo de los logs del sistema ---"
    echo "Respaldos de logs guardados en el sistema:"
    ls -l /root/respaldos_logs/*.tar.gz 2>/dev/null || echo "No hay respaldos de logs."
    read -p "Ingrese el nombre del archivo a restaurar: " respaldo_logs
    if [ -f "/root/respaldos_logs/$respaldo_logs" ]; then
        tar -xzvf "/root/respaldos_logs/$respaldo_logs" -C /root/logs_restaurados
        echo "Respaldo de logs restaurado exitosamente en /root/logs_restaurados."
    else
        echo "[ERROR] El archivo no existe."
    fi
    read -p "Presione ENTER para continuar..." pausa
}

function eliminar_respaldo(){
    clear
    echo "--- Eliminando respaldo ---"
    echo "--- BD ---"
    ls -l /root/respaldos_bd/*.sql 2>/dev/null
    echo "--- Logs ---"
    ls -l /root/respaldos_logs/*.tar.gz 2>/dev/null

    read -p "Ingrese la ruta completa del archivo a eliminar: " archivo
    if [ -f "$archivo" ]; then
        rm -i "$archivo"
        echo "Respaldo procesado."
    else
        echo "[ERROR] Archivo no encontrado."
    fi
    read -p "Presione ENTER para continuar..." pausa
}

function listar_respaldos(){
    clear
    echo "--- Listando respaldos disponibles ---"
    echo "Respaldos de BD:"
    ls -l /root/respaldos_bd/*.sql 2>/dev/null || echo "Ninguno."
    echo ""
    echo "Respaldos de logs del sistema:"
    ls -l /root/respaldos_logs/*.tar.gz 2>/dev/null || echo "Ninguno."
    read -p "Presione ENTER para continuar..." pausa
}

function configurar_programacion_respaldos(){
    clear
    echo "--- Configurando programación de respaldos ---"
    crontab -e
    read -p "Presione ENTER para continuar..." pausa
}

function enviar_respaldo_remoto(){
    clear
    echo "--- Enviando respaldo a ubicación remota ---"
    read -p "Ingrese la ruta del archivo local: " archivo
    read -p "Ingrese usuario@servidor_remoto: " destino
    read -p "Ingrese directorio remoto destino: " dir_remoto

    if [ -f "$archivo" ]; then
        scp "$archivo" "${destino}:${dir_remoto}"
        echo "Respaldo enviado exitosamente."
    else
        echo "[ERROR] El archivo local no existe."
    fi
    read -p "Presione ENTER para continuar..." pausa
}

# MAIN
while [ $opc -ne 0 ]
do
    menu
    read -p "Ingrese la opción: " opc

    case $opc in
        1) crear_respaldo_bd ;;
        2) crear_respaldo_logs ;;
        3) restaurar_respaldo_bd ;;
        4) restaurar_respaldo_logs ;;
        5) eliminar_respaldo ;;
        6) listar_respaldos ;;
        7) configurar_programacion_respaldos ;;
        8) enviar_respaldo_remoto ;;
        0)
            clear
            echo "Saliendo del programa... ¡Hasta luego!"
            break ;;
        *)
            echo "[ERROR] Opción incorrecta. Por favor ingrese un número del 0 al 8."
            read -p "Presione ENTER para continuar..." pausa
        ;;
    esac
done
       
