## CLAPS v0.2 (Cloud Local Administrator Password Solution)

### agent.ps1

- Trabaja con el sid500.
- Cifra las credenciales con un certificado.
- Manda las credenciales cifradas a una función de Azure Function.
- Actualiza las credenciales del sid500.
- A modo de depuración exporta las credenciales en claro a pwd.txt y las credenciales cifradas a secret.txt.


### function.ps1

- Recibe las credenciales cifradas.
- Usa la versión 1 de PowerShell en Azure Functions (SLAPS).
- Se autentica contra Azure Key Vault para obtener el token de acceso y poder trabajar con el servicio.
- Guarda en un vault de Azure Key Vault las credenciales cifradas como un secreto.


https://srdn.io/2018/09/serverless-laps-powered-by-microsoft-intune-azure-functions-and-azure-key-vault/
