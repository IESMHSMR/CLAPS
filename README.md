# CLAPS v0.5 (Cloud Local Administrator Password Solution)

## Índice

- [Documentación técnica](#documentación-técnica)
- [Introducción](#introducción)
    - [Objetivos](#objetivos)
    - [¿Qué es CLAPS?](#qué-es-claps)
    - [¿Cómo funciona?](#cómo-funciona)
    - [¿Para quién es?](#para-quién-es)
- [Conceptos](#conceptos)
    - [Azure Functions](#azure-functions)
    - [Azure Key Vault](#azure-key-vault)
    - [SID500](#SID500)
- [Contenido del repositorio](#contenido-del-repositorio)
    - [Azure Functions](Azure%20Functions/README.md)
        - [FunctionEncrypt.ps1](#functionencrypt.ps1)
        - [FunctionDecrypt.ps1](#functiondecrypt.ps1)
    - [Agent](Agent/README.md)
        - [Claps.ps1](#claps.ps1)
    - [Admin](Admin/README.md)
        - [Decrypt.ps1](#decrypt.ps1)
- [Versiones](#versiones)
- [Recursos](#recursos)

### Documentación Técnica
Esta documentación es meramente introductoria para conocer el proyecto, si quieres saber más te aconsejo ir a la [documentación técnica](https://github.com/Velaa98/CLAPS/wiki).


### Introducción
En un entorno empresarial de Windows cuando hablamos de un dominio implicamos la necesidad de un administrador para el mismo, damos por hecho que al ser una cuenta con altos privilegios dentro de la organización debe estar protegida correctamente. Al ser una única cuenta o un número limitado de ellas, no habría gran inconveniente en gestionar credenciales seguras y únicas para cada una de ellas.

Por otro lado también tenemos al administrador local de cada equipo del dominio, y aquí es donde llega el problema: ¿Qué hacemos con las credenciales de estos administradores?

Son cuentas a las cuales en un entorno enlos usuarios no deben tener acceso y para ello deben ser protegidas correctamente, para evitar un ataque con saltos laterales entre equipos descartamos la opción de una contraseña segura pero igual para todos los equipo. Con el mismo objetivo descartamos usar patrones que al ser averiguados por un atacante pueda de igual modo saltar lateralmente. Por ende, ¿cómo lo hacemos?.


#### Objetivos
Aumentar la seguridad del dominio evitando la reutilización de credenciales para usuarios privilegiados.


#### ¿Qué es CLAPS?
Es mi propuesta para suplir una carencia real y presente en las empresas que hacen uso de servicios actuales como es Azure Active Directory.


#### ¿Cómo funciona?
Es posible principalmente gracias a servicios en la nube como Azure Key Vault y Azure Functions.
Está desarrollado en su totalidad con PowerShell y su código está disponible para todos [aquí](https://github.com/Velaa98/CLAPS/tree/master#versiones). Para una explicación más extensa y detallada del funcionamiento interno puedes mirar la [documentación técnica](https://github.com/Velaa98/CLAPS/wiki/Funcionamiento%20Interno).


#### ¿Para quién es?
Para aquellas empresas que hacen uso de Azure Active Directory y quieren las ventajas de LAPS en la nube.


### Conceptos

#### Azure Functions
Es un servicio de Azure que nos permite ejecutar código en respuesta a diversos eventos sin necesidad de tener la infraestructura que ello implicaría.

#### Azure Key Vault
Es un servicio de Azure que proporcina un almacenamiento seguro para claves, secretos de aplicaciones y certificados. Estos pueden ser utilizados de forma segura por otros recursos o aplicaciones de la nube.

#### SID500
Es la mejor forma de identificar al administrador local de los equipos en sistemas Windows, su homólogo en UNIX es el usuario con UID 0.

### Contenido del repositorio
#### [Claps.ps1](Agent/Claps.ps1)
Es el agente instalado en los equipos encargado de generar las nuevas credenciales, enviarlas a Azure Functions y según la respuesta de esta, actualizar las credenciales del administrador local.

#### [FunctionEncrypt.ps1](Azure%20Functions/FunctionEncrypt.ps1)
Función de Azure encargada de evaluar las llamadas por parte de los equipos y almacenar las credenciales cifradas. 

#### [Decrypt.ps1](Admin/Decrypt.ps1)
Aplicación que permite a un usuario autorizado solicitar las credenciales del administrador local de un equipo, para ello trabaja con Azure Functions.

#### [FunctionDecrypt.ps1](Azure%20Functions/FunctionDecrypt.ps1)
Función de Azure que se encarga de descifrar las credenciales del administrador local para el equipo solicitado.


### Versiones

- [stable](https://github.com/Velaa98/CLAPS)
- [upcoming](https://github.com/Velaa98/CLAPS/tree/v0.6)
- [testing](https://github.com/Velaa98/CLAPS/tree/testing)
- [v0.5](https://github.com/Velaa98/CLAPS/tree/v0.5)
- [v0.4](https://github.com/Velaa98/CLAPS/tree/v0.4)
- [v0.3](https://github.com/Velaa98/CLAPS/tree/v0.3)
- [v0.2](https://github.com/Velaa98/CLAPS/tree/v0.2)
- [v0.1](https://github.com/Velaa98/CLAPS/tree/v0.1)


### Recursos

- [Documentación de Microsoft Graph](https://docs.microsoft.com/en-us/graph)
- [API Microsoft Graph](https://docs.microsoft.com/en-us/graph/use-the-api)
    - [Probador de Graph](https://developer.microsoft.com/en-us/graph/graph-explorer)
    - [Access Token sin usuario](https://docs.microsoft.com/en-us/graph/auth-v2-service)
    - [Datos personalizados en Graph usando extensiones abiertas](https://docs.microsoft.com/en-us/graph/extensibility-open-users)
    - [Permisos para crear extensiones abiertas](https://docs.microsoft.com/en-us/graph/api/opentypeextension-post-opentypeextension?view=graph-rest-1.0#permissions)
    - [Trabajando con las extensiones abiertas de un dispositivo](https://stackoverflow.com/a/56218052/11497286)
- [Documentación de Azure Functions](https://docs.microsoft.com/es-es/azure/azure-functions/)
- [Documentación de Azure Key Vault](https://docs.microsoft.com/en-us/azure/key-vault/key-vault-whatis)
- [API Azure Key Vault](https://docs.microsoft.com/es-es/rest/api/keyvault)
    - [Cifrar con una clave](https://docs.microsoft.com/en-us/rest/api/keyvault/encrypt/encrypt)
    - [Descifrar con una clave](https://docs.microsoft.com/en-us/rest/api/keyvault/decrypt/decrypt)
- [Script ps1 como servicio de Windows](https://www.reddit.com/r/PowerShell/comments/59f94d/run_powershell_script_ps1_as_a_windows_service/)
- [LAPS](https://docs.microsoft.com/en-us/previous-versions/mt227395(v=msdn.10))
- [SLAPS](https://srdn.io/2018/09/serverless-laps-powered-by-microsoft-intune-azure-functions-and-azure-key-vault)
    - [John Seerden](https://www.srdn.io/about/)