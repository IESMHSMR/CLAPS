function Get-Token
{
    $scopes = "Directory.AccessAsUser.All"

    #Redirects to this URL will show a 404 in your browser, but allows you to copy the returned code from the URL bar
    #Must match a redirect URL for your registered application
    $redirectURL = "https://login.microsoftonline.com/common/oauth2/nativeclient"

    $credential = Get-Credential -Message "Enter the client ID and client secret"
    
    $clientID = $credential.Username
    $clientSecret = [System.Web.HttpUtility]::UrlEncode($credential.GetNetworkCredential().Password)

    #v2.0 authorize URL
    $authorizeUrl = "https://login.microsoftonline.com/common/oauth2/v2.0/authorize"

    #Permission scopes
    $requestUrl = $authorizeUrl + "?scope=$scopes"

    #Code grant, will receive a code that can be redeemed for a token
    $requestUrl += "&response_type=code"

    #Add your app's Application ID
    $requestUrl += "&client_id=$clientID"

    #Add your app's redirect URL
    $requestUrl += "&redirect_uri=$redirectURL"

    #Options for response_mode are "query" or "form_post". We want the response
    #to include the data in the querystring
    $requestUrl += "&response_mode=query"

    Write-Host
    Write-Host "Copy the following URL and paste the following into your browser:"
    Write-Host
    Write-Host $requestUrl -ForegroundColor Cyan
    Write-Host
    Write-Host "Copy the code querystring value from the browser and paste it below."
    Write-Host
    $code = Read-Host -Prompt "Enter the code"

    $body = "client_id=$clientID&client_secret=$clientSecret&scope=$scopes&grant_type=authorization_code&code=$code&redirect_uri=$redirectURL"
    
    #v2.0 token URL
    $tokenUrl = "https://login.microsoftonline.com/common/oauth2/v2.0/token"

    $response = Invoke-RestMethod -Method Post -Uri $tokenUrl -Headers @{"Content-Type" = "application/x-www-form-urlencoded"} -Body $body

    #Pass the access_token in the Authorization header to the Microsoft Graph
    $token = $response.access_token
    
    return $token
}

$token=Get-Token
