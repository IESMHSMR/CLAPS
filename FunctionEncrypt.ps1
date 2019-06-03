using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

$apiVersionAuth = "2017-09-01"
$apiVersionVault = "7.0"
$resourceURI = "https://vault.azure.net"
$keyVaultName = ""

$endp = $env:MSI_ENDPOINT -replace ".$"
$tokenAuthURI = $env:MSI_ENDPOINT+"?resource=$resourceURI&api-version=$apiVersionAuth"
$tokenResponse = Invoke-RestMethod -Method Get -Headers @{"Secret"="$env:MSI_SECRET"} -Uri $tokenAuthURI
$accessToken = $tokenResponse.access_token
$authHeader = @{ Authorization = "Bearer $accessToken" }

try {
    <#
    $uri = "https://$keyVaultName.vault.azure.net/secrets?api-version=7.0"
    $resp = Invoke-RestMethod -Method Get -Uri $uri -Headers $authHeader
    #>

    #<#
    $body = $Request.body | Select-Object -Property * -ExcludeProperty keyName
    $body = $body | ConvertTo-Json
    $vaultSecretUri = "https://$keyVaultName.vault.azure.net/secrets/$($Request.Body.keyName)?api-version=$apiVersionVault"
    $resp = Invoke-RestMethod -Method Put -Body $body -Uri $vaultSecretUri -ContentType 'application/json' -Headers $authHeader
    #>
    $status = [HttpStatusCode]::OK
}
catch {
    $status = [HttpStatusCode]::BadRequest
}


# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $status
    Body =  $resp
})
