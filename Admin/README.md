## Decrypt.ps1

- Obtiene un token de acceso para trabajar con la API de Microsoft Graph.
- Consulta todos los DeviceID del AAD y los imprime por pantalla con el formato "DeviceID : DisplayName".
- Llama a "FunctionDecrypt.ps1" y le manda el DeviceID del equipo para el cual queremos obtener las credenciales del sid500.
- Espera la respuesta de la función con las credenciales en claro para el sid500 del equipo indicado.