$client_id = ""
$clientSecret = ""

$scopes = "Directory.AccessAsUser.All"

$redirectURL = "https://login.microsoftonline.com/common/oauth2/nativeclient"

$authorizeUrl = "https://login.microsoftonline.com/common/oauth2/v2.0/authorize"
$requestUrl = $authorizeUrl + "?scope=$scopes"
$requestUrl += "&response_type=code"
$requestUrl += "&client_id=$client_id"
$requestUrl += "&redirect_uri=$redirectURL"
$requestUrl += "&response_mode=query"

Write-Host $requestUrl -ForegroundColor Cyan
$code = Read-Host -Prompt "Enter the code"

$body = "client_id=$client_id&client_secret=$clientSecret&scope=$scopes&grant_type=authorization_code&code=$code&redirect_uri=$redirectURL"
$tokenUrl = "https://login.microsoftonline.com/common/oauth2/v2.0/token"
$response = Invoke-RestMethod -Method Post -Uri $tokenUrl -Headers @{"Content-Type" = "application/x-www-form-urlencoded"} -Body $body
$token = $response.access_token


Connect-AzureAD
$DeviceId = ((dsregcmd.exe /status | Where-Object {$_ -like '*DeviceId*'}) -split ' : ')[1]
$ObjectId = (Get-AzureADDevice | Where-Object{$_.DeviceId -eq $DeviceId}).ObjectId


<#
## Listar extensiones
$apiUrl = "https://graph.microsoft.com/v1.0/devices/$ObjectId/extensions"
$Data = Invoke-RestMethod -Headers @{Authorization = "Bearer $token"} -Uri $apiUrl -Method Get
$Data.value | fl

## Añadir extensiones
$apiUrl = "https://graph.microsoft.com/v1.0/devices/$ObjectId/extensions"
$body = '{
  "@odata.type": "microsoft.graph.openTypeExtension",
  "id": "admin.key",
  "key": "prueba"
}'
Invoke-RestMethod -Headers @{Authorization = "Bearer $token"; "Content-type" = "application/json"} -Uri $apiUrl -Method Post -Body $body
#>


$user = Get-LocalUser -Name prueba
[Reflection.Assembly]::LoadWithPartialName("System.Web")
$clear_pwd = ([system.web.security.membership]::GeneratePassword(15,4)) -replace '[?/#]+',''

$clear_pwd | Out-File -FilePath C:\Temp\pwd.txt -Append

$encrypt = $clear_pwd | Protect-CmsMessage -To cn=claps

## Actualizar datos de una extensión
$apiUrl = "https://graph.microsoft.com/v1.0/devices/$ObjectId/extensions/admin.key"
$body = "{
  '@odata.type': 'microsoft.graph.openTypeExtension',
  'id': 'admin.key',
  'key': ""$encrypt""
}"
Invoke-RestMethod -Headers @{Authorization = "Bearer $token"; "Content-type" = "application/json"} -Uri $apiUrl -Method Patch -Body $body

$pwd = ConvertTo-SecureString -AsPlainText -String $clear_pwd -Force

Set-LocalUser -SID $user.SID -Password $pwd -ErrorAction Stop
