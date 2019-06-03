## CLAPS v0.4 (Cloud Local Administrator Password Solution)

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

- 


### Ampliaciones

- 


### Versiones

- [stable](https://github.com/Velaa98/CLAPS)
- [upcoming](https://github.com/Velaa98/CLAPS/tree/v0.4)
- [testing](https://github.com/Velaa98/CLAPS/tree/testing)
- [v0.3](https://github.com/Velaa98/CLAPS/tree/v0.3)
- [v0.2](https://github.com/Velaa98/CLAPS/tree/v0.2)
- [v0.1](https://github.com/Velaa98/CLAPS/tree/v0.1)

### Webgrafía

- https://docs.microsoft.com/es-es/azure/app-service/overview-managed-identity#code-examples
- https://docs.microsoft.com/es-es/azure/active-directory/managed-identities-azure-resources/services-support-managed-identities#azure-key-vault
- https://docs.microsoft.com/es-es/azure/active-directory/managed-identities-azure-resources/howto-assign-access-portal
- https://docs.microsoft.com/es-es/rest/api/keyvault
- https://docs.microsoft.com/en-us/rest/api/keyvault/updatesecret/updatesecret
- https://docs.microsoft.com/en-us/rest/api/keyvault/setsecret/setsecret
- https://docs.microsoft.com/en-us/rest/api/keyvault/getsecret/getsecret
