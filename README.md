# *** KAIROS ***
Kairos es una herramienta avanzada para pentesting en Active Directory, diseñada para automatizar y facilitar la escalada de privilegios, administración de certificados, ataques y persistencia en sistemas mediante técnicas de evasión.

<div style="display: flex; gap: 10px;">
    <img src="https://github.com/user-attachments/assets/321e9bb8-9c1e-4cf3-b16d-286f95d5a1fe" alt="220px-Francesco_Salviati_005" width="250" height="300">
    <img src="https://github.com/user-attachments/assets/1658ca01-538b-4743-a327-38817624bb16" alt="Kairos-Relief_von_Lysippos,_Kopie_in_Trogir" width="250" height="300">
</div>

---

### ***Kairos***

## Descripción

Kairos es una herramienta avanzada de pentesting diseñada para fortalecer la seguridad en entornos de Active Directory (AD). Su enfoque se centra en automatizar los procesos de escalada de privilegios, la gestión de certificados, la persistencia y técnicas de evasión, optimizando y simplificando las tareas críticas de administración y seguridad en redes complejas.

El nombre "Kairos" proviene de la mitología griega y representa el "momento oportuno" o "tiempo adecuado", el instante crítico en el que una oportunidad única debe ser aprovechada para obtener un resultado ideal. En el contexto de ciberseguridad, Kairos simboliza la capacidad de detectar y aprovechar oportunidades precisas para realizar ataques y defensas estratégicas en los momentos clave.

Este concepto, profundamente arraigado en la filosofía y literatura griega, evoca la importancia de tomar decisiones rápidas y efectivas, actuando con agudeza, audacia y adaptabilidad. Kairos es, en esencia, una herramienta que facilita la identificación y explotación de esos momentos críticos en los que la seguridad puede ser reforzada o vulnerada, convirtiendo las oportunidades en una ventaja táctica para mejorar la resiliencia y control de los sistemas AD.

## Características

Kairos automatiza y ejecuta varias funciones de pentesting en Active Directory. A continuación se detallan las principales:

Convertir Certificado PFX a PEM:

Convierte un archivo PFX a formato PEM para su uso en autenticación basada en certificados.
Detección de Vulnerabilidades en ADCS:

Verifica configuraciones inseguras en Active Directory Certificate Services.
Solicitar Ticket de Servicio (TGT):

Solicita un TGT (Ticket Granting Ticket) mediante Certipy para autenticación en el dominio.
Extracción de TGT:

Extrae y guarda el TGT solicitado en un archivo de log para su uso posterior.
Autenticación usando TGT:

Utiliza el TGT para autenticarse y realizar volcados de datos en el Controlador de Dominio.
Enumeración de ACLs:

Usa SharpHound para listar ACLs (Listas de Control de Acceso) y buscar rutas de escalada de privilegios.
Escalada de Privilegios:

Identifica permisos como WriteDACL en cuentas de servicio y realiza escalada de privilegios.
Ataque NTLM Relay:

Verifica dispositivos vulnerables y lanza un ataque de relay NTLM si se detectan vulnerabilidades.
Volcado de NTDS:

Realiza un volcado de los datos NTDS para recopilar información confidencial en el dominio.
Persistencia y Evasión:

Genera un Golden Ticket usando Mimikatz para mantener acceso persistente al dominio.
Ofuscación del Script:

Ofusca el script principal para evitar detección y facilitar técnicas de evasión.


## Requisitos

Antes de instalar **Kairos**, asegúrate de cumplir con los siguientes requisitos:

- **Sistema Operativo**: Linux (preferiblemente una distribución basada en Debian o Red Hat).
- **Bash**: Versión 4.0 o superior.
- **Python**: 3.x y las bibliotecas requeridas (ver más abajo).
- **Herramientas Adicionales**:
  - OpenSSL
  - Certipy
  - Impacket
  - SharpHound
  - Mimikatz
  - ntlmrelayx

## Instalación

### 1. Clonar el Repositorio

Abre una terminal y ejecuta:

```bash
git clone https://github.com/espinozan/kairos.git
cd kairos
```

### 2. Instalar Kairos

Instalación con el Script
La instalación de Kairos implica el uso de install_kairos.sh, que configura todas las herramientas necesarias para que Kairos funcione correctamente.

## *Script de instalacion de kairos *(**install_kairos.sh**)*

### Ejecutar el Script de Instalación

Dar Permisos de Ejecución:

```bash
chmod +x install_kairos.sh
```
### Ejecutar la Instalación Completa:

Usa la opción -p para instalar todas las herramientas necesarias

```bash
./install_kairos.sh -p
```
# Uso de Kairos

Para ejecutar Kairos, utiliza el script **kairos.sh**, que incluye múltiples opciones para adaptarse a distintos escenarios de pentesting.

## Parámetros de Ejecución

Ejemplo de uso:

```bash
./kairos.sh -d DOMAIN -u USER -p PASS -c CERT_PATH -a ADCS_IP -i DC_IP -o NTDS_DUMP_PATH
```

### Argumentos:

- `-d DOMAIN`: Nombre del dominio (por ejemplo, empresa.local).
- `-u USER`: Nombre de usuario en Active Directory que se utilizará para la autenticación.
- `-p PASS`: Contraseña de usuario.
- `-c CERT_PATH`: Ruta al archivo PFX del certificado (ejemplo: `/path/to/certificate.pfx`).
- `-a ADCS_IP`: Dirección IP del servidor de Certificación ADCS (Active Directory Certificate Services).
- `-i DC_IP`: Dirección IP del Controlador de Dominio.
- `-o NTDS_DUMP_PATH`: Ruta donde se almacenarán los volcados de datos NTDS (ejemplo: `/path/to/ntds_dump`).

### Funcionamiento

**Kairos** se ejecuta en una serie de pasos secuenciales que automatizan el proceso de pentesting en entornos de Active Directory:

1. **Conversión de Certificados**: Utiliza OpenSSL para convertir el certificado PFX en formato PEM. Este paso es esencial para la posterior autenticación.

2. **Detección de Configuraciones Inseguras**:
   - Ejecuta Certipy con el comando `find` para identificar configuraciones inseguras en el servidor ADCS.
   - Este paso permite conocer las vulnerabilidades existentes y ayuda en la planeación de ataques posteriores.

3. **Solicitud de TGT**:
   - Utiliza Certipy para solicitar un Ticket Granting Ticket (TGT) utilizando las credenciales proporcionadas.
   - Este ticket es fundamental para acceder a otros recursos en el dominio.

4. **Extracción y Autenticación**:
   - Extrae el TGT de los logs generados por Certipy.
   - Se autentica contra el controlador de dominio usando el TGT, lo que proporciona acceso a los recursos de AD.

5. **Enumeración de ACLs**:
   - Utiliza SharpHound para enumerar las listas de control de acceso (ACLs) de los objetos dentro del dominio.
   - Esto identifica las posibles rutas de escalada de privilegios.

6. **Escalada de Privilegios**:
   - Analiza los resultados de la enumeración de ACLs en busca de permisos excesivos.
   - Ejecuta PowerUp para detectar y explotar vulnerabilidades relacionadas con escalada de privilegios.

7. **Ataques de Relay y Volcado de NTDS**:
   - Realiza un escaneo con nmap para detectar dispositivos vulnerables al ataque NTLM Relay.
   - Usa Impacket para llevar a cabo el volcado del NTDS, que extrae las credenciales de los usuarios del controlador de dominio.

8. **Persistencia y Evasión**:
   - Genera Golden Tickets usando Mimikatz para asegurar el acceso a largo plazo.
   - Aplica técnicas de evasión para evitar ser detectado por sistemas de seguridad.

9. **Ofuscación**:
   - El script se ofusca utilizando codificación base64 para evitar su detección por herramientas de seguridad.
   - Esto ayuda a asegurar que las actividades de pentesting sean menos visibles para los sistemas de defensa.

## Consideraciones de Seguridad

- **Uso Responsable**: **Kairos** está diseñado para ser utilizado por profesionales de la ciberseguridad y pentesters. No utilices esta herramienta en sistemas sin autorización explícita.
- **Ética**: Asegúrate de seguir las mejores prácticas éticas en ciberseguridad al realizar pruebas de penetración. Obtén siempre el permiso adecuado antes de ejecutar pruebas en un entorno de producción.
- **Cumplimiento Legal**: Verifica que tus acciones sean legales en la jurisdicción donde operas. La falta de cumplimiento puede tener consecuencias legales graves.

## Contribuciones

Las contribuciones son bienvenidas. Por favor, sigue el siguiente proceso:

1. Realiza un fork del repositorio.
2. Crea una nueva rama para tu característica o corrección.
3. Envía un pull request explicando tu contribución.

## Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo `LICENSE` para más detalles.

## Contacto

Si tienes preguntas o sugerencias, no dudes en contactarme a través de mi perfil de GitHub: [espinozan](https://github.com/espinozan).

---
