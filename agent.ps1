# Azure Function Uri
$uri = ''

## Administrator del equipo con sid500.
$sid500 = Get-LocalUser | Where-Object { $_.SID -like "S-1-5-*-500" }

## Si la cuenta con sid500 no está habilitada, intenta habilitarla.
if($sid500.Enabled -eq $false)
{
    try {
        Enable-LocalUser -SID $sid500.SID
    }
    catch {}
}

## Genera las credenciales. (15,4) Caráctares en total y 4 de ellos no alfanumericos.
[Reflection.Assembly]::LoadWithPartialName("System.Web")
$clear_pwd = ([system.web.security.membership]::GeneratePassword(15,4))

## ID de dispositivo.
$DeviceId = ((dsregcmd.exe /status | Where-Object {$_ -like '*DeviceId*'}) -split ' : ')[1]

## Datos enviados a la función.
$body = @"
    {
    "DeviceName": "$env:COMPUTERNAME",
    "DeviceId": "$DeviceId",
    "UserName": "$env:USERNAME",
    "Password": "$clear_pwd"
    }
"@

## Use TLS 1.2 connection
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    $Response = Invoke-RestMethod -Uri $uri -Method POST -Body $body -ErrorAction Stop
}
catch {}

if ($Response -eq 'Se han actualizado las credenciales.') {
    $pwd = ConvertTo-SecureString -AsPlainText -String $clear_pwd -Force
    Set-LocalUser -SID $sid500.SID -Password $pwd -ErrorAction Stop
}
