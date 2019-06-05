# CLAPS v0.5 (Cloud Local Administrator Password Solution)

## Índice

- [Introducción](#introducción)
    - [Objetivos](#objetivos)
    - [¿Qué es CLAPS?](#¿qué-es-claps?)
    - [¿Cómo funciona?](#¿cómo-funciona?)
    - [¿Es para todos?](#¿es-para-todos?)
    - [¿Para quién es?](#¿para-quién-es?) (o a quién va destinado)
- [Conceptos](#conceptos)
    - [LAPS, SLAPS y CLAPS](#laps,-slaps-y-claps)
    - [Azure Functions](#azure-functions)
    - [Azure Key Vault](#azure-key-vault)
- [Requisitos](#requisitos)
- [Contenido del repositorio](#contenido-del-repositorio)
    - [Azure Functions](Azure%20Functions/README.md)
        - [FunctionEncrypt.ps1](#functionencrypt.ps1)
        - [FunctionDecrypt.ps1](#functiondecrypt.ps1)
    - [Agent](Agent/README.md)
        - [Claps.ps1](#claps.ps1)
    - [Admin](Admin/README.md)
        - [Decrypt.ps1](#decrypt.ps1)
- [Esquema](#esquema)
- [Ampliaciones](#ampliaciones)
    - [Integridad de datos](#integridad-de-datos)
    - [Seguridad](#seguridad)
    - [Funcionalidades](#funcionalidades)
- [Problemas identificados](#problemas-identificados)
- [Conclusiones](#conclusiones)
- [Versiones](#versiones)
- [Webgrafía](#webgrafía)



### Introducción
En un entorno Windows cuando hablamos de un dominio implicamos la necesidad de un administrador para el mismo, damos por hecho que al ser una cuenta con altos privilegios dentro de la organización debe estar protegida correctamente. Al ser una única cuenta o un número límitado de ellas, no habría gran inconveniente en gestionar credenciales seguras y únicas para cada una de ellas.

Por otro lado también tenemos al administrador de cada equipo del dominio, y aquí es donde llega el problema: ¿Qué hacemos con las credenciales de estos administradores locales?

Son cuentas a las cuales los usuarios no deben tener acceso y para ello deben ser protegidas correctamente, para evitar un ataque con saltos laterales entre equipos descartamos la opción de una contraseña segura pero igual para todos los equipo. Con el mismo objetivo descartamos usar patrones que al ser averiguados por un atacante pueda de igual modo saltar lateralmente. Por ende, ¿cómo lo hacemos?.


#### Objetivos
Solucionar el problema comentado y por ende aumentar la seguridad del dominio gestionando las credenciales del administrador local de cada equipo unido al dominio,

 de forma que en ningún caso serán iguales ni tendrán una validez indefinida.
 de forma que serán aleatorias, cumpliendo una serie de requisitos previamente establecidos y con una validez límitada.


#### ¿Qué es CLAPS?
Es mi propuesta para suplir una carencia real y presente en las empresas.
Es mi propuesta para suplir los objetivos establecidos.

#### ¿Cómo funciona?
Es posible principalmente gracias a servicios en la nube como Azure Key Vault y Azure Functions.
Está desarrollado en su totalidad con PowerShell y su código está disponible para todos [aquí](https://github.com/Velaa98/CLAPS/tree/master#versiones)

#### ¿Es para todos?
No. Sus potenciales clientes están muy bien delimitados.
No. Sus usos están muy bien delimitados.

#### ¿Para quién es?
Para aquellas empresas (que disponen)/(hacen uso) de Azure Active Directory y quieren las ventajas de LAPS en la nube.


### Conceptos
#### Azure Functions
Es un servicio de Azure que nos permite ejecutar código en respuesta a diversos eventos sin necesidad de tener la infraestructura que ello implicaría.

#### Azure Key Vault
Es un servicio de Azure que proporcina un almacenamiento seguro para claves, secretos de aplicaciones y certificados. Estos pueden ser utilizados de forma segura por otros recursos o aplicaciones de la nube.


#### LAPS, SLAPS y CLAPS
Todas tienen en común su objetivo principal, sin embargo ninguna de ellas funcionan igual...



#### LAPS
LAPS (Local Administrator Password Solution) es una solución de Microsoft para solventar los objetivos que se comentan...

#### SLAPS
SLAPS (Serverless Administrator Password Solution) es una solución creada por John Seerden como primera alternativa a LAPS si nos encontramos en un entorno en la nube. 

#### LAPS vs SLAPS/CLAPS
LAPS está pensado para trabajar con Active Directory a diferencia de SLAPS o CLAPS, que están pensados para trabajar en la nube con Azure Active Directory.

#### Active Directory vs Azure Active Directory



##################
# CLAPS vs SLAPS #
##################
Dos soluciones para el mismo problema





### Requisitos
- 



### Contenido del repositorio
#### [Claps.ps1](Agent/Claps.ps1)
Es el agente instalado en los equipos encargado de generar las nuevas credenciales, enviarlas a Azure Functions y según la respuesta de esta, actualizar las credenciales del administrador local.

#### [FunctionEncrypt.ps1](Azure%20Functions/FunctionEncrypt.ps1)
Función de Azure encargada de evaluar las llamadas por parte de los equipos y almacenar las credenciales cifradas. 

#### [Decrypt.ps1](Admin/Decrypt.ps1)
Aplicación que permite a un usuario autorizado solicitar las credenciales del administrador local de un equipo, para ello trabaja con Azure Functions.

#### [FunctionDecrypt.ps1](Azure%20Functions/FunctionDecrypt.ps1)
Función de Azure que se encarga de descifrar las credenciales del administrador local para el equipo solicitado.



### Esquema




### Ampliaciones
#### Integridad de datos
- 

#### Seguridad
- Autenticación con el usuario para usar decrypt.ps1.

#### Funcionalidades
- Establecer y gestionar la periodicidad del cambio de credenciales.
- Definir el método de distribución e instalación del agente.
- Logs en local y en la nube.
- Auditoria para ver quien ha usado Decrypt.ps1 y para que equipo.


### Problemas identificados
- No hay comprobaciones para asegurar la integridad de los datos, si se actualizan las credenciales almacenadas en la extensión de dispositivo y el cliente no cambia las credenciales, se pierde el acceso.



### Versiones

- [stable](https://github.com/Velaa98/CLAPS)
- [upcoming](https://github.com/Velaa98/CLAPS/tree/v0.6)
- [testing](https://github.com/Velaa98/CLAPS/tree/testing)
- [v0.5](https://github.com/Velaa98/CLAPS/tree/v0.5)
- [v0.4](https://github.com/Velaa98/CLAPS/tree/v0.4)
- [v0.3](https://github.com/Velaa98/CLAPS/tree/v0.3)
- [v0.2](https://github.com/Velaa98/CLAPS/tree/v0.2)
- [v0.1](https://github.com/Velaa98/CLAPS/tree/v0.1)



### Webgrafía

- [Identidades Administradas](https://docs.microsoft.com/es-es/azure/active-directory/managed-identities-azure-resources/)
- [Servicios de Azure que admiten Identidades Administradas](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/services-support-managed-identities#azure-key-vault)
- [Permitiendo el acceso de una identidad administrada a un recurso de Azure](https://docs.microsoft.com/es-es/azure/active-directory/managed-identities-azure-resources/howto-assign-access-portal)
- [Access Token para usar una identidad administrada](https://docs.microsoft.com/es-es/azure/app-service/overview-managed-identity#code-examples)
- [Documentación de Microsoft Graph](https://docs.microsoft.com/en-us/graph)
- [API Microsoft Graph](https://docs.microsoft.com/en-us/graph/use-the-api)
    - [Probador de Graph](https://developer.microsoft.com/en-us/graph/graph-explorer)
    - [Access Token sin usuario](https://docs.microsoft.com/en-us/graph/auth-v2-service)
    - [Datos personalizados en Graph usando extensiones abiertas](https://docs.microsoft.com/en-us/graph/extensibility-open-users)
    - [Permisos para crear extensiones abiertas](https://docs.microsoft.com/en-us/graph/api/opentypeextension-post-opentypeextension?view=graph-rest-1.0#permissions)
    - [Trabajando con las extensiones abiertas de un dispositivo](https://stackoverflow.com/a/56218052/11497286)
- [API Azure Active Directory Graph](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-graph-api)
- [Documentación de Azure Functions](https://docs.microsoft.com/es-es/azure/azure-functions/)
- [Documentación de Azure Key Vault](https://docs.microsoft.com/en-us/azure/key-vault/key-vault-whatis)
- [Cuenta gratuita de Azure](https://azure.microsoft.com/es-es/free/)
- [Precios de Azure Key Vault](https://azure.microsoft.com/es-es/pricing/details/key-vault/)
- [API Azure Key Vault](https://docs.microsoft.com/es-es/rest/api/keyvault)
    - [Actualizar secretos](https://docs.microsoft.com/en-us/rest/api/keyvault/updatesecret/updatesecret)
    - [Crear nuevos secretos](https://docs.microsoft.com/en-us/rest/api/keyvault/setsecret/setsecret)
    - [Obtener un secreto](https://docs.microsoft.com/en-us/rest/api/keyvault/getsecret/getsecret)
    - [Cifrar con una clave](https://docs.microsoft.com/en-us/rest/api/keyvault/encrypt/encrypt)
    - [Descifrar con una clave](https://docs.microsoft.com/en-us/rest/api/keyvault/decrypt/decrypt)
- [Script ps1 como servicio de Windows](https://www.reddit.com/r/PowerShell/comments/59f94d/run_powershell_script_ps1_as_a_windows_service/)
- [LAPS](https://docs.microsoft.com/en-us/previous-versions/mt227395(v=msdn.10))
- [SLAPS](https://srdn.io/2018/09/serverless-laps-powered-by-microsoft-intune-azure-functions-and-azure-key-vault)
    - [John Seerden](https://www.srdn.io/about/)
        - [GitHub](https://github.com/jseerden)