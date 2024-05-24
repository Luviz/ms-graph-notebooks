param (
    [Parameter(Mandatory)]
    [string]
    $CsvPath,
    [char]
    $CsvDelimiter = ','
)

## Configuration 
## APP information
$tenantId = "8f4baa8a-c188-4891-8a8c-0b7d53418c93"
$clientId = "69be8a05-bd02-42b1-8435-235bc1fd56ba"
$clientSecret = "<secret>"

# login with id secret
$scope = "https://graph.microsoft.com/.default"
$tokenUrl = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"
$msGraph = "https://graph.microsoft.com/v1.0"


function Get-AccessToken {
    $body = @{
        grant_type    = "client_credentials"
        client_id     = $clientId
        client_secret = $clientSecret
        scope         = $scope
    }

    $response = Invoke-WebRequest -Uri $tokenUrl -Method Post -ContentType "application/x-www-form-urlencoded" -Body $body
    $responseData = $response.Content | ConvertFrom-Json
    return $responseData.access_token
} 

$token = Get-AccessToken 
$headers = @{
    Authorization = "Bearer $token"
}

## Remove Items

function Remove-DriveItem {
    [CmdletBinding()]
    param (
        # User id
        [Parameter(Mandatory)]
        [string]
        $UserId,
        # Folder id
        [Parameter(Mandatory)]
        [string]
        $FileId
    )

    $url = "$msGraph/users/$UserId/drive/items/$FileId/permanentDelete"
    Invoke-WebRequest -Uri $url -Method Post -Headers $headers
}

function Read-DriveItemsFromCSV {
    [Cmdletbinding()]
    param(
        # Path to file
        [Parameter(Mandatory)]
        [string]
        $path
    )

    return Get-Content $path | ConvertFrom-Csv -Delimiter $CsvDelimiter | Select-Object id, userId, name
}

$filesToBeRemove = Read-DriveItemsFromCSV -path $CsvPath
$filesToBeRemove | Select-Object -First 20 | Format-Table
Write-Host "There are $($filesToBeRemove.Length) file(s) to removed, do you want to continue (y,N)"
$conform = Read-Host

if ($conform.ToLower() -ne "y") {
    write-host "Exiting..."
    Exit-PSSession
    return 1
}


foreach ($item in $filesToBeRemove) {
    Write-Host "Removing $($item.id)..."
    Remove-DriveItem -UserId $item.userId -FileId $item.id
}