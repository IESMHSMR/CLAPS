# Azure Function Uri (containing "azurewebsites.net") for storing Local Administrator secret in Azure Key Vault
$uri = ''

$sid500 = Get-LocalUser | Where-Object { $_.SID -like "S-1-5-*-500" }
[Reflection.Assembly]::LoadWithPartialName("System.Web")
$clear_pwd = ([system.web.security.membership]::GeneratePassword(15,4)) -replace '[?/#]+',''

$Date= Get-Date -Format yyyy-MM-dd

## Debug
"$Date : $clear_pwd" | Out-File -FilePath C:\Temp\pwd.txt -Append

$encrypt = $clear_pwd | Protect-CmsMessage -To cn=claps

## Debug
$encrypt| Out-File -FilePath C:\Temp\secret.txt -Append

$body = @"
    {
    "keyName": "$env:COMPUTERNAME",
    "contentType": "Local Administrator Credentials",
    "tags": {
            "Username": "$env:USERNAME"
            },
    "value": "$encrypt"
    } 
"@


# Use TLS 1.2 connection
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    Invoke-RestMethod -Uri $uri -Method POST -Body $body -ErrorAction Stop
}
catch {
    Write-Error "Failed to submit Local Administrator configuration. StatusCode: $($_.Exception.Response.StatusCode.value__). StatusDescription: $($_.Exception.Response.StatusDescription)"
}

$pwd = ConvertTo-SecureString -AsPlainText -String $clear_pwd -Force

Set-LocalUser -SID $sid500.SID -Password $pwd -ErrorAction Stop
