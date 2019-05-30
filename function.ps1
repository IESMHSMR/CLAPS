# POST method: $req
$requestBody = Get-Content $req -Raw | ConvertFrom-Json

# Config
$keyVaultName = ""

# Azure Key Vault resource to obtain access token
$vaultTokenUri = 'https://vault.azure.net'
$apiVersion = '2017-09-01'

# Get Azure Key Vault Access Token using the Function's Managed Service IdentityB
$authToken = Invoke-RestMethod -Method Get -Headers @{ 'Secret' = $env:MSI_SECRET } -Uri "$($env:MSI_ENDPOINT)?resource=$vaultTokenUri&api-version=$apiVersion"

# Use Azure Key Vault Access Token to create Authentication Header
$authHeader = @{ Authorization = "Bearer $($authToken.access_token)" }

# Generate a new body to set a secret in the Azure Key Vault
$body = $requestBody | Select-Object -Property * -ExcludeProperty keyName

# Convert the body to JSON
$body = $body | ConvertTo-Json

# Azure Key Vault Uri to set a secret
$vaultSecretUri = "https://$keyVaultName.vault.azure.net/secrets/$($requestBody.keyName)/?api-version=2016-10-01"

# Set the secret in Azure Key Vault
$null = Invoke-RestMethod -Method PUT -Body $body -Uri $vaultSecretUri -ContentType 'application/json' -Headers $authHeader
