### Step 1) Install or import the azure module.

```
Install-Module AzureAD
Import-Module AzureAD
```

### Step 2) Search Object and save ObjectID. (Note: The "id" in the request is the "id" property of the device, not the "deviceId" property.)

```	
$ObjectID = (Get-AzureADDevice -SearchString 'Object-Name').ObjectId
```

### Step 3) [Create App](https://github.com/microsoftgraph/msgraph-training-authentication/tree/master/Demos/01-rest-via-powershell#register-the-application-for-getting-tokens-using-rest)

- https://portal.azure.com - Azure Active Directory - App registrations - New registration
- Name: YourAppName
- account types: Accounts in this organizational directory only (Default Directory)
- URI: (WEB)  https://login.microsoftonline.com/common/oauth2/nativeclient


### Step 4) Configure App

https://portal.azure.com - Azure Active Directory - App registrations - YourAppName

#### Create a client secret 
Certificates & secrets - New client secret (save secret value)

#### Configure permissions
 API permissions - Add a permission - Microsoft Graph - Delegated permissions
- Directory.AccessAsUser.All


### Step 5) [Get access token](https://github.com/Velaa98/msgraph-training-authentication/tree/master/Demos/01-rest-via-powershell#create-the-powershell-script)

```
	$scopes = "Directory.AccessAsUser.All"
	$redirectURL = "https://login.microsoftonline.com/common/oauth2/nativeclient"
	
	$clientID = "YourAppIdClient"
	$clientSecret = [System.Web.HttpUtility]::UrlEncode("YourAppClientSecret")
	$authorizeUrl = "https://login.microsoftonline.com/common/oauth2/v2.0/authorize"
	
	$requestUrl = $authorizeUrl + "?scope=$scopes"
	$requestUrl += "&response_type=code"
    $requestUrl += "&client_id=$clientID"
    $requestUrl += "&redirect_uri=$redirectURL"
    $requestUrl += "&response_mode=query"	
	
	Write-Host "Copy the following URL and paste the following into your browser:"
    Write-Host $requestUrl -ForegroundColor Cyan
    Write-Host "Copy the code querystring value from the browser and paste it below."
    $code = Read-Host -Prompt "Enter the code"

	$body = "client_id=$clientID&client_secret=$clientSecret&scope=$scopes&grant_type=authorization_code&code=$code&redirect_uri=$redirectURL"
	$tokenUrl = "https://login.microsoftonline.com/common/oauth2/v2.0/token"
	$response = Invoke-RestMethod -Method Post -Uri $tokenUrl -Headers @{"Content-Type" = "application/x-www-form-urlencoded"} -Body $body
	$token = $response.access_token
```

## Working with device extensions

### Get Extensions device	
	
```
$apiUrl = 'https://graph.microsoft.com/v1.0/devices/<ID-Object>/extensions'
$Data = Invoke-RestMethod -Headers @{Authorization = "Bearer $accessToken"} -Uri $apiUrl -Method Get
$Data.Value | fl
```


### Add extensions device

```
$apiUrl = 'https://graph.microsoft.com/v1.0/devices/<ID-Object>/extensions'
$body = '{
  "@odata.type": "microsoft.graph.openTypeExtension",
  "id": "test.extension",
  "value": "example"
  }'
Invoke-RestMethod -Headers @{Authorization = "Bearer $token"; "Content-type" = "application/json"} -Uri $apiUrl -Method Post -Body $body
```

### Update extensions device

```
$apiUrl = 'https://graph.microsoft.com/v1.0/devices/<ID-Object>/extensions/test.extension' ## Extension ID to update
$body = '{
  "@odata.type": "microsoft.graph.openTypeExtension",
  "id": "test.extension",
  "value": "new_value"
  }'
Invoke-RestMethod -Headers @{Authorization = "Bearer $token"; "Content-type" = "application/json"} -Uri $apiUrl -Method Patch -Body $body
```

### Delete extensions device

```
$apiUrl = 'https://graph.microsoft.com/v1.0/devices/<ID-Object>/extensions/test.extension'
Invoke-RestMethod -Headers @{Authorization = "Bearer $token"; "Content-type" = "application/json"} -Uri $apiUrl -Method Delete
```

## Resources
- [Graph Explorer](https://developer.microsoft.com/es-es/graph/graph-explorer#)
- [Permissions](https://docs.microsoft.com/en-us/graph/permissions-reference)
- [Open extension](https://docs.microsoft.com/en-us/graph/api/resources/opentypeextension?view=graph-rest-1.0)
- [Get](https://docs.microsoft.com/en-us/graph/api/opentypeextension-get?view=graph-rest-1.0)
- [Add](https://docs.microsoft.com/en-us/graph/api/opentypeextension-post-opentypeextension?view=graph-rest-1.0)
- [Update](https://docs.microsoft.com/en-us/graph/api/opentypeextension-update?view=graph-rest-1.0)
- [Delete](https://docs.microsoft.com/en-us/graph/api/opentypeextension-delete?view=graph-rest-1.0)
- [stackoverflow](https://stackoverflow.com/a/56218052/11497286)
