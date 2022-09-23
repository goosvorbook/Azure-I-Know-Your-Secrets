Write-Output "        _  _"
Write-Output "  __ _ (_)| | __ _   _  ___"
Write-Output " / _` || || |/ /| | | |/ __|"
Write-Output "| (_| || ||   < | |_| |\__ \"
Write-Output " \__,_||_||_|\_\ \__, ||___/"
Write-Output "                 |___/"


# Get Managed Service Identity info from Azure Functions Application Settings
$msiEndpoint = $env:MSI_ENDPOINT
$msiSecret = $env:MSI_SECRET

# If we use a User Assigned Managed Identity, you will have to collect the ClientID first
$headers=@{"secret"=$env:IDENTITY_HEADER}
$ClientId = "" # The Client ID of the user assigned identity, do not forget to set this


Write-Output "MSI Endpoint"
Write-Output $msiEndpoint
Write-Output "MSI Secret"
Write-Output $msiSecret

# Specify URI and Token AuthN Request Parameters
$apiVersion = "2017-09-01"
$resourceURI = "https://graph.microsoft.com"
$tokenAuthURI = $msiEndpoint + "?resource=$resourceURI&api-version=$apiVersion"

# Authenticate with MSI and get Token
$tokenResponse = Invoke-RestMethod -Method Get -Headers @{"Secret"="$msiSecret"} -Uri $tokenAuthURI

# This response should give us a System Bearer Token for later use in Graph API calls
$systemaccessToken = $tokenResponse.access_token

Write-Output "Access Token for a System Managed Service Account"
Write-Output $systemaccessToken

# Querying the Graph API with a User ClientID
$userResponse = Invoke-RestMethod -Method Get -Uri "$($env:IDENTITY_ENDPOINT)?resource=https://graph.microsoft.com/&clientid=$ClientId&api-version=$apiVersion" -Headers $headers

# This response should give us a User Bearer Token for later use in Graph API calls
$useraccessToken = $userResponse.access_token


Write-Output "Access Token for a User Managed Service Account"
Write-Output $useraccessToken
