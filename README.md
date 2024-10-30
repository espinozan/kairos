# kairos
Kairos es una herramienta avanzada de pentesting diseñada específicamente para entornos de Active Directory (AD).

![wikii] 


!(https://en.wikipedia.org/wiki/File:Francesco_Salviati_005.jpg)


---

### ***Kairos***

## Descripción

**Kairos** es una herramienta avanzada de pentesting diseñada específicamente para entornos de Active Directory (AD). Su objetivo principal es automatizar el proceso de escalada de privilegios, gestionar certificados y aplicar técnicas de persistencia para mejorar la seguridad y la administración de redes complejas.

El nombre "Kairos" proviene de la antigua Grecia, donde significa "el momento oportuno" o "el tiempo adecuado". En el contexto de la ciberseguridad, se refiere a aprovechar la oportunidad perfecta para ejecutar ataques y defensas, convirtiendo momentos críticos en ventajas estratégicas.

## Características

- **Automatización Inteligente de Escalada de Privilegios**: Integración con herramientas como SharpHound y PowerUp para detectar permisos excesivos y ejecutar escaladas automáticamente.
  
- **Gestión de Certificados y Autenticación Kerberos**: Solicitud de Tickets Granting Tickets (TGT) mediante Certipy, con capacidades para detectar configuraciones inseguras en Active Directory Certificate Services (ADCS).

- **Ataques Automatizados de Relay y Mimikatz**: Implementación de técnicas avanzadas como NTLM Relay y DCSync para la obtención de credenciales.

- **Obfuscación y Persistencia**: Aplicación de técnicas de evasión contra sistemas de detección (EDR) y generación de Golden Tickets para asegurar el acceso persistente.

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

### 2. Instalar Dependencias

Asegúrate de tener Python 3 y pip instalados. Luego, instala las dependencias requeridas ejecutando:

```bash
pip install -r requirements.txt
```

### 3. Instalación de Certipy

Descarga Certipy desde su [repositorio oficial](https://github.com/Optiv/Certipy) y colócalo en `/path/Certipy/`.

### 4. Instalación de Impacket

Sigue las instrucciones en el [repositorio oficial de Impacket](https://github.com/SecureAuthCorp/impacket) para instalarlo. Asegúrate de que esté accesible en tu PATH.

### 5. Instalación de SharpHound

Descarga SharpHound y colócalo en `/path/SharpHound/`.

### 6. Instalación de Mimikatz

Descarga Mimikatz y colócalo en `/path/Mimikatz/`.

### 7. Dar permisos de ejecución al script

Asegúrate de que el script tenga permisos de ejecución:

```bash
chmod +x script.sh
```

## Uso

### Ejemplo de Uso

Para ejecutar **Kairos**, usa el siguiente comando en la terminal:

```bash
./script.sh -d DOMAIN -u USER -p PASS -c CERT_PATH -a ADCS_IP -i DC_IP -o NTDS_DUMP_PATH
```

### Argumentos

- `-d DOMAIN`: Especifica el dominio de Active Directory.
- `-u USER`: Nombre de usuario que se utilizará para la autenticación.
- `-p PASS`: Contraseña del usuario.
- `-c CERT_PATH`: Ruta al certificado en formato PFX (ejemplo: `/path/to/certificate.pfx`).
- `-a ADCS_IP`: Dirección IP del servidor de Active Directory Certificate Services (ADCS).
- `-i DC_IP`: Dirección IP del controlador de dominio (DC).
- `-o NTDS_DUMP_PATH`: Ruta donde se almacenará el volcado NTDS (ejemplo: `/path/to/ntds_dump`).

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
