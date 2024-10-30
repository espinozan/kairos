#!/bin/bash

set -o pipefail

### Descripción y Propósito del Script ###
# Este script instalará las herramientas necesarias para realizar pentesting en entornos de Active Directory,
# incluyendo Rubeus, PowerView, Certipy, SharpHound, Mimikatz y sus dependencias.

### Función: Mostrar uso ###
usage() {
    echo "Uso: $0 [opciones]"
    echo "Opciones:"
    echo "  -h         Muestra este mensaje de ayuda"
    echo "  -p         Instala todas las herramientas y dependencias"
    echo "  -r         Solo actualiza las herramientas"
    exit 1
}

### Función: Instalar dependencias de sistema ###
install_dependencies() {
    echo "Instalando dependencias del sistema..."
    sudo apt-get update -y
    sudo apt-get install -y python3 python3-pip git openssl nmap
}

### Función: Clonar y configurar Rubeus ###
install_rubeus() {
    echo "Clonando e instalando Rubeus..."
    git clone https://github.com/GhostPack/Rubeus.git /opt/Rubeus
    cd /opt/Rubeus
    # Compilación de Rubeus (asumiendo que tienes Visual Studio o dotnet)
    dotnet build Rubeus.sln
    cd -
}

### Función: Clonar y configurar PowerView ###
install_powerview() {
    echo "Clonando PowerView..."
    git clone https://github.com/PowerShellEmpire/PowerTools.git /opt/PowerTools
    mv /opt/PowerTools/PowerView /opt/PowerView
}

### Función: Instalar Certipy ###
install_certipy() {
    echo "Instalando Certipy..."
    pip3 install certipy
}

### Función: Clonar y configurar SharpHound ###
install_sharphound() {
    echo "Clonando SharpHound..."
    git clone https://github.com/BloodHoundAD/SharpHound.git /opt/SharpHound
}

### Función: Clonar y configurar Mimikatz ###
install_mimikatz() {
    echo "Clonando e instalando Mimikatz..."
    git clone https://github.com/gentilkiwi/mimikatz.git /opt/mimikatz
    cd /opt/mimikatz
    # Compilación de Mimikatz si es necesario
    mingw32-make
    cd -
}

### Función: Mensaje de finalización ###
finish() {
    echo "Instalación completada. Todas las herramientas están listas para usar."
}

### Ejecución Principal ###
main() {
    while getopts ":hpr" opt; do
        case "${opt}" in
            h) usage ;;
            p) 
                install_dependencies
                install_rubeus
                install_powerview
                install_certipy
                install_sharphound
                install_mimikatz
                finish
                ;;
            r)
                echo "Actualizando herramientas..."
                # Aquí podrías agregar lógica para actualizar las herramientas
                ;;
            *) usage ;;
        esac
    done

    if [ "$OPTIND" -eq 1 ]; then
        usage
    fi
}

main "$@"
