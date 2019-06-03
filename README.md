# CLAPS v0.5 (Cloud Local Administrator Password Solution)


### Agent.ps1

- Genera las credenciales.
- Obtiene el DeviceID del equipo.
- Llama a "FunctionEncrypt.ps1" y le manda las credenciales y el DeviceID.
- Espera la respuesta de la función para actualizar las credenciales del sid500.


### FunctionEncrypt.ps1

- Recibe las credenciales y un DeviceID.
- Obtiene un token para trabajar con la API de Microsoft Graph.
- Busca el ObjectID que corresponde al DeviceID recibido.
- Comprueba que TrustType del ObjectID en cuestión es AzureAd
- Obtiene un token para trabajar con la API de Azure Key Vault.
- Pasa las credenciales a Base64.
- Manda las credenciales a la API de Key Vault y las recibe cifradas.
- Comprueba si existe la extensión de claps para actualizarla o crearla con las credenciales cifradas.
- Si no ha habido ningún error, devuelve al cliente que realizó la llamada la confirmación para actualizar las credenciales del sid500.


### Decrypt.ps1

- Obtiene un token de acceso para trabajar con la API de Microsoft Graph.
- Consulta todos los DeviceID del AAD y los imprime por pantalla con el formato "DeviceID : DisplayName".
- Llama a "FunctionDecrypt.ps1" y le manda el DeviceID del equipo para el cual queremos obtener las credenciales del sid500.
- Espera la respuesta de la función con las credenciales en claro para el sid500 del equipo indicado.


### FunctionDecrypt.ps1

- Recibe el DeviceID correspondiente al equipo para el cual se desea obtener las credenciales del sid500.
- Obtiene un token de acceso para trabajar con la API de Microsoft Graph.
- Consulta las credenciales cifradas que corresponden al DeviceID.
- Obtiene un token para trabajar con la API de Azure Key Vault.
- Manda las credenciales cifradas a la API de Key Vault y las recibe descifradas.
- Decodifica las credenciales de Base64 a Unicode.
- Devuelve al cliente que realizó la llamada las credenciales del sid500 del equipo indicado.


### Problemas identificados

- No hay comprobaciones para asegurar la integridad de los datos, si se actualizan las credenciales almacenadas en la extensión de dispositivo y el cliente no cambia las credenciales, se pierde el acceso.


### Ampliaciones

- Autenticación con el usuario para usar decrypt.ps1.
- Establecer y gestionar la periodicidad del cambio de credenciales.


### Versiones

- [stable](https://github.com/Velaa98/CLAPS)
- [upcoming](https://github.com/Velaa98/CLAPS/tree/v0.5)
- [testing](https://github.com/Velaa98/CLAPS/tree/testing)
- [v0.4](https://github.com/Velaa98/CLAPS/tree/v0.4)
- [v0.3](https://github.com/Velaa98/CLAPS/tree/v0.3)
- [v0.2](https://github.com/Velaa98/CLAPS/tree/v0.2)
- [v0.1](https://github.com/Velaa98/CLAPS/tree/v0.1)

### Webgrafía

- [Identidades Administradas](https://docs.microsoft.com/es-es/azure/active-directory/managed-identities-azure-resources/)
- [Servicios de Azure que admiten Identidades Administradas](https://docs.microsoft.com/es-es/azure/active-directory/managed-identities-azure-resources/services-support-managed-identities#azure-key-vault)
- [Permitiendo el acceso de una identidad administrada a un recurso de Azure](https://docs.microsoft.com/es-es/azure/active-directory/managed-identities-azure-resources/howto-assign-access-portal)
- [Access Token para usar una identidad administrada](https://docs.microsoft.com/es-es/azure/app-service/overview-managed-identity#code-examples)
- [Documentación de Microsoft Graph](https://docs.microsoft.com/en-us/graph)
- [API Microsoft Graph](https://docs.microsoft.com/en-us/graph/use-the-api)
    - [Probador de Graph](https://developer.microsoft.com/en-us/graph/graph-explorer)
    - [Access Token sin usuario](https://docs.microsoft.com/en-us/graph/auth-v2-service)
    - [Datos personalizados en Graph usando extensiones abiertas](https://docs.microsoft.com/en-us/graph/extensibility-overview)
    - [Permisos para crear extensiones abiertas](https://docs.microsoft.com/en-us/graph/api/opentypeextension-post-opentypeextension?view=graph-rest-1.0#permissions)
    - [Trabajando con las extensiones abiertas de un dispositivo](https://stackoverflow.com/a/56218052/11497286)
    - []()
- [API Azure Key Vault](https://docs.microsoft.com/es-es/rest/api/keyvault)
    - [Actualizar secretos](https://docs.microsoft.com/en-us/rest/api/keyvault/updatesecret/updatesecret)
    - [Crear nuevos secretos](https://docs.microsoft.com/en-us/rest/api/keyvault/setsecret/setsecret)
    - [Obtener un secreto](https://docs.microsoft.com/en-us/rest/api/keyvault/getsecret/getsecret)
    - []()
- []()
- [SLAPS](https://srdn.io/2018/09/serverless-laps-powered-by-microsoft-intune-azure-functions-and-azure-key-vault)