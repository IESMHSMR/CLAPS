$uri = ""


## Access Token para trabajar con graph.
$TenantId=""
$AppId=""
$AppSecret=""
$ApiVersionOauth2 = "v2.0"
$ScopesGraph = "https://graph.microsoft.com/.default"
$UrlGraph = 'https://graph.microsoft.com/v1.0/'
try {
    $ResponseOauth = Invoke-RestMethod -Uri https://login.microsoftonline.com/$TenantId/oauth2/$apiVersionOauth2/token -Method Post -Body @{
        "grant_type" = "client_credentials";
        "client_id" = "$AppId";
        "client_secret" = "$AppSecret";
        "scope" = "$ScopesGraph"
    }

    $AccessTokenGraph = $ResponseOauth.access_token
    $authHeaderGraph = @{ Authorization = "Bearer $AccessTokenGraph" }
}
catch {
    Write-Host "No se ha podido obtener el access token para la api de graph."
}

## Devuelve una lista con los ID de dispositivo y el nombre del equipo en Azure.
try {
    $UrlCheckDeviceId = $UrlGraph + "Devices"
    $DevicesList = Invoke-RestMethod -Headers $authHeaderGraph -Uri $UrlCheckDeviceId -Method Get
    
    Clear-Host

    foreach ($device in $DevicesList.value) {
        Write-Host $device.deviceid " : " $device.displayName
    }
}
catch {
    Write-Host "No encuentra el ID de objeto para el DeviceID especificado"
}

Write-Host ""
$DeviceID = Read-Host -Prompt "DeviceID"

$body = @"
    {
        "DeviceId": "$DeviceID"
    }
"@

$Response = Invoke-RestMethod -Uri $uri -Method Post -Body $body -ErrorAction Stop

Write-Host "Password:" -ForegroundColor Yellow
Write-Host "$Response" -ForegroundColor Yellow

Start-Sleep 10
