## CLAPS v0.4 (Cloud Local Administrator Password Solution)

### agent.ps1

- Trabaja con el sid500.
- Cifra las credenciales con un certificado.
- Manda las credenciales cifradas a una función de Azure Function.
- Actualiza las credenciales del sid500.
- A modo de depuración exporta las credenciales en claro a pwd.txt y las credenciales cifradas a secret.txt.


### function.ps1

- Recibe las credenciales cifradas.
- Usa la versión 2 de PowerShell en Azure Functions.
- Se autentica contra Azure Key Vault para obtener el token de acceso y poder trabajar con el servicio.
- Guarda en un vault de Azure Key Vault las credenciales cifradas como un secreto.


### Webgrafía

- https://docs.microsoft.com/es-es/azure/app-service/overview-managed-identity#code-examples
- https://docs.microsoft.com/es-es/azure/active-directory/managed-identities-azure-resources/services-support-managed-identities#azure-key-vault
- https://docs.microsoft.com/es-es/azure/active-directory/managed-identities-azure-resources/howto-assign-access-portal
- https://docs.microsoft.com/es-es/rest/api/keyvault
- https://docs.microsoft.com/en-us/rest/api/keyvault/updatesecret/updatesecret
- https://docs.microsoft.com/en-us/rest/api/keyvault/setsecret/setsecret
- https://docs.microsoft.com/en-us/rest/api/keyvault/getsecret/getsecret
