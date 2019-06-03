using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# $DeviceName = $Request.Body.DeviceName
#$UserName = $Request.Body.UserName
$DeviceId = $Request.Body.DeviceId
$Password = $Request.Body.Password

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
    $status = [HttpStatusCode]::BadRequest
}

## Comprueba que el dispositivo que realiza la llamada es válido para usar la función y devuelve el ObjectId del mismo.
try {
    $UrlCheckDeviceId = $UrlGraph + "Devices"
    $DevicesList = Invoke-RestMethod -Headers $authHeaderGraph -Uri $UrlCheckDeviceId -Method Get
    $Device = $DevicesList.value | Where-Object{$_.deviceId -eq $DeviceId}
    $ObjectID, $TrustType = $Device.id, $Device.trustType

    if ($TrustType -eq "AzureAd") { $status = [HttpStatusCode]::OK }
    else {
        $ObjectID = "Workplace"
        Write-Host "El tipo de confianza de la unión no es válida."
        $status = [HttpStatusCode]::BadRequest
    }
}
catch {
    Write-Host "No encuentra el ID de objeto para el DeviceID especificado."
}

## Si se encuentra el dispositivo que corresponde al DeviceId recibido:
if ($ObjectID -and $ObjectID -ne "Workplace") {
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
        $status = [HttpStatusCode]::BadRequest
    }


    ## Establece las cabeceras para la solicitud.
    $HeadersKeyVault = $authHeaderKeyVault + @{"Content-type" = "application/json"}

    ## Cifrado de las credenciales con una clave de KeyVault.
    try {
        ## Url para el cifrado de las credenciales.
        $UriEncryptCredentials = "https://$KeyVaultName.vault.azure.net/keys/$KeyVaultKeyName/$KeyVaultKeyVersion/encrypt?api-version=$apiVersionVault"

        $Bytes = [System.Text.Encoding]::Unicode.GetBytes($Password)
        $PasswordInBase64 =[Convert]::ToBase64String($Bytes)

        ## Cuerpo de la solicitud para cifrar las credenciales con el algoritmo de cifrado y las credenciales.
        $body = (@{ "alg" = "$AlgEncrypt"; "value" = "$PasswordInBase64"}) | ConvertTo-Json
        
        ## Respuesta de la API con las credenciales cifradas.
        $ResponseKeyVaultEncrypt = Invoke-RestMethod -Method Post -Uri $UriEncryptCredentials -Headers $HeadersKeyVault -Body $body 

        ## Credenciales cifradas
        $PasswordEncrypt = $ResponseKeyVaultEncrypt.value
        
        ## Url de la clave con la que se ha cifrado los datos.
        $UrlKeyEncryptCredentials = $ResponseKeyVaultEncrypt.kid
        
        $status = [HttpStatusCode]::OK
    }
    catch {
        $status = [HttpStatusCode]::BadRequest
    }
    
    ## Comprueba si existe la extensión de claps en el dispositivo:
    try {
        $UrlCheckClapsExtension = $UrlGraph + "Devices/" + $ObjectID + "/extensions/" + $ClapsExtensionName
        $ExistsClapsExtension = Invoke-RestMethod -Headers $authHeaderGraph -Uri $UrlCheckClapsExtension -Method Get
        $status = [HttpStatusCode]::OK
    }
    catch {
        $status = [HttpStatusCode]::BadRequest
    }

    ## Establece las cabeceras para las solicitudes contra Graph.
    $HeadersGraph = $authHeaderGraph + @{"Content-type" = "application/json"}

    ## Establece la estructura de la extensión de claps.
    $ClapsExtensionEstructure = @"
{
    '@odata.type': 'microsoft.graph.openTypeExtension',
    'id': "$ClapsExtensionName",
    'adminCredentials': "$PasswordEncrypt",
    'algEncrypt': "$AlgEncrypt",
    'kid': "$UrlKeyEncryptCredentials"
}
"@

    ## Si existe trbaja con ella:
    if ($ExistsClapsExtension) {
        try {
            ## Url para actualizar la extensión de claps con las nuevas credenciales.
            $UrlUpdateClapsExtension = $UrlGraph + "Devices/" + $ObjectID + "/extensions/" + $ClapsExtensionName
            ## Actualización de la extensión de claps.
            $UpdateClapsExtension = Invoke-RestMethod -Headers $HeadersGraph -Uri $UrlUpdateClapsExtension -Method Patch -Body $ClapsExtensionEstructure
            $resp = 'Se han actualizado las credenciales.'
            $status = [HttpStatusCode]::OK
        }
        catch {
            $status = [HttpStatusCode]::BadRequest
        }
    }
    ## si no existe la crea:
    elseif (!$ExistsClapsExtension) {
        try {
            ## Url para crear la extensión de claps con las credenciales.
            $UrlCreateClapsExtension = $UrlGraph + "Devices/" + $ObjectID + "/extensions"
            ## Solicitud para crear la extensión:
            $CreateClapsExtension = Invoke-RestMethod -Headers $HeadersGraph -Uri $UrlCreateClapsExtension -Method Post -Body $ClapsExtensionEstructure
            $resp='Se ha creado la extensión y se ha almacenado las credenciales.'
            $status = [HttpStatusCode]::OK
        }
        catch {
            $status = [HttpStatusCode]::BadRequest
        }
    }
}
## Si no se encuentra el dispositivo que corresponde al DeviceId recibido:
elseif ($ObjectID -eq 'Workplace') {
    $status = [HttpStatusCode]::BadRequest
}
elseif (!$ObjectID) {
    $status = [HttpStatusCode]::BadRequest
}

## Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $status
    Body = $resp
})
