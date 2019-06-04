using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

$DeviceId = $Request.Body.DeviceId

## Variables Azure Key Vault:
$ApiVersionAuth = "2017-09-01"
$ApiVersionVault = "7.0"
$ResourceUri_1 = "https://vault.azure.net"
$KeyVaultName = ""
$KeyVaultKeyName = ""
$KeyVaultKeyVersion = ""
$AlgEncrypt = ""

## Variables Microsoft Graph:
$ApiVersionOauth2 = "v2.0"
$ScopesGraph = "https://graph.microsoft.com/.default"
$UrlGraph = 'https://graph.microsoft.com/v1.0/'
$ClapsExtensionName = ""


## Access Token para trabajar con graph.
$TenantId=""
$AppId=""
$AppSecret=""
try {
    $ResponseOauth = Invoke-RestMethod -Uri https://login.microsoftonline.com/$TenantId/oauth2/$apiVersionOauth2/token -Method Post -Body @{
        "grant_type" = "client_credentials";
        "client_id" = "$AppId";
        "client_secret" = "$AppSecret";
        "scope" = "$ScopesGraph"
    }

    $AccessTokenGraph = $ResponseOauth.access_token
    $authHeaderGraph = @{ Authorization = "Bearer $AccessTokenGraph" }
    $status = [HttpStatusCode]::OK
}
catch {
    Write-Host "No se ha podido obtener el access token para la api de graph."
    $resp = 'No se ha podido obtener el access token para la api de graph.'
    $status = [HttpStatusCode]::BadRequest
}

## Busca el ObjectId que corresponde al DeviceId recibido.
try {
    $UrlCheckDeviceId = $UrlGraph + "Devices"
    $DevicesList = Invoke-RestMethod -Headers $authHeaderGraph -Uri $UrlCheckDeviceId -Method Get
    $Device = $DevicesList.value | Where-Object{$_.deviceId -eq $DeviceId}
    $ObjectID = $Device.id

    $status = [HttpStatusCode]::OK
}
catch {
    Write-Host "No encuentra el ID de objeto para el DeviceID especificado."
    $resp = 'No encuentra el ID de objeto para el DeviceID especificado.'    
    $status = [HttpStatusCode]::BadRequest
}

## Si se encuentra el dispositivo que corresponde al DeviceId recibido:
if ($ObjectID) {
    ## Recupera las credenciales cifradas de la extensión de claps:
    try {
        $UrlGetEncryptCredentials = $UrlGraph + "Devices/" + $ObjectID + "/extensions/" + $ClapsExtensionName
        $ResponseGraphCredentials = Invoke-RestMethod -Headers $authHeaderGraph -Uri $UrlGetEncryptCredentials -Method Get
        $PasswordEncrypted = $ResponseGraphCredentials.value.adminCredentials
        $ObjectID = $Device.id

        $status = [HttpStatusCode]::OK
    }
    catch {
        Write-Host "No encuentra el ID de objeto para el DeviceID especificado."
        $resp = 'No encuentra el ID de objeto para el DeviceID especificado.'    
        $status = [HttpStatusCode]::BadRequest
    }

    ## Access Token para trabajar con KeyVault.
    try {
        $endp = $env:MSI_ENDPOINT -replace ".$"
        $tokenAuthURI = $env:MSI_ENDPOINT+"?resource=$resourceUri_1&api-version=$apiVersionAuth"
        $ResponseKeyVault = Invoke-RestMethod -Method Get -Headers @{"Secret"="$env:MSI_SECRET"} -Uri $tokenAuthURI
        $AccessTokenKeyVault = $ResponseKeyVault.access_token
        $authHeaderKeyVault = @{ Authorization = "Bearer $AccessTokenKeyVault" }
        $status = [HttpStatusCode]::OK
    }
    catch {
        Write-Host "No se ha podido obtener el access token para KeyVault."
        $resp = "No se ha podido obtener el access token para KeyVault."
        $status = [HttpStatusCode]::BadRequest
    }


    ## Establece las cabeceras para la solicitud.
    $HeadersKeyVault = $authHeaderKeyVault + @{"Content-type" = "application/json"}

    ## Cifrado de las credenciales con una clave de KeyVault.
    try {
        ## Url para el cifrado de las credenciales.
        $UriDecryptCredentials = "https://$KeyVaultName.vault.azure.net/keys/$KeyVaultKeyName/$KeyVaultKeyVersion/decrypt?api-version=$apiVersionVault"

        ## Cuerpo de la solicitud para cifrar las credenciales con el algoritmo de cifrado y las credenciales.
        $body = (@{ "alg" = "$AlgEncrypt"; "value" = "$PasswordEncrypted"}) | ConvertTo-Json
        
        ## Respuesta de la API con las credenciales cifradas.
        $ResponseKeyVaultDecrypt = Invoke-RestMethod -Method Post -Uri $UriDecryptCredentials -Headers $HeadersKeyVault -Body $body 

        ## Credenciales descifradas
        $PasswordDecryptedInBase64 = $ResponseKeyVaultDecrypt.value
        
        ## Url de la clave con la que se ha cifrado los datos.
        $PasswordDecrypted = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($PasswordDecryptInBase64))
        
        $status = [HttpStatusCode]::OK
    }
    catch {
        Write-Host "No se ha podido cifrar las credenciales."
        $resp = "No se ha podido cifrar las credenciales."
        $status = [HttpStatusCode]::BadRequest
    }
}
## Si no se encuentra el dispositivo que corresponde al DeviceId recibido:
elseif (!$ObjectID) {
    $resp = "No se ha encontrado el DeviceId"
    Write-Host 'No se ha encontrado el DeviceId'
    $status = [HttpStatusCode]::BadRequest
}


# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $status
    Body = $PasswordDecrypted
})

