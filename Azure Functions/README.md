## FunctionEncrypt.ps1

- Recibe las credenciales y un DeviceID.
- Obtiene un token para trabajar con la API de Microsoft Graph.
- Busca el ObjectID que corresponde al DeviceID recibido.
- Comprueba que TrustType del ObjectID en cuestión es AzureAd
- Obtiene un token para trabajar con la API de Azure Key Vault.
- Pasa las credenciales a Base64.
- Manda las credenciales a la API de Key Vault y las recibe cifradas.
- Comprueba si existe la extensión de claps para actualizarla o crearla con las credenciales cifradas.
- Si no ha habido ningún error, devuelve al cliente que realizó la llamada la confirmación para actualizar las credenciales del sid500.


## FunctionDecrypt.ps1

- Recibe el DeviceID correspondiente al equipo para el cual se desea obtener las credenciales del sid500.
- Obtiene un token de acceso para trabajar con la API de Microsoft Graph.
- Consulta las credenciales cifradas que corresponden al DeviceID.
- Obtiene un token para trabajar con la API de Azure Key Vault.
- Manda las credenciales cifradas a la API de Key Vault y las recibe descifradas.
- Decodifica las credenciales de Base64 a Unicode.
- Devuelve al cliente que realizó la llamada las credenciales del sid500 del equipo indicado.