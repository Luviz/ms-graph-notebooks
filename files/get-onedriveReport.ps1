# Fill i nedan
## APP infomation
$tenantId = "8f4baa8a-c188-4891-8a8c-0b7d53418c93"
$clientId = "1c0887a1-2b6c-4a95-9dfb-53901c3049a5"
$clientSecret = "<secret>"

## User Infomation 
$userId = "07b076e1-9273-44ab-afc2-4653303eb368"

# login with id secret
$scope = "https://graph.microsoft.com/.default"
$tokenUrl = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"
$msGraph = "https://graph.microsoft.com/v1.0"

function get-accessToken {
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

$token = get-accessToken 
$headers = @{
    Authorization = "Bearer $token"
}

function get-folderItems {
    [CmdletBinding()]
    param (
        # User id
        [Parameter(Mandatory)]
        [string]
        $UserId,
        # Folder id
        [Parameter(Mandatory)]
        [string]
        $FolderId
    )

    $url = "$msGraph/users/$userId/drive/items/$folderId/children"
    $res = Invoke-WebRequest -Uri $url -Headers $headers
    if ($res.StatusCode -eq 200) {
        return $($res.Content | ConvertFrom-Json).value
    }
    Write-Error "Something went wrong!!"
    Exit-PSSession
}

function get-userFiles {
    param (
        # User id
        [Parameter(Mandatory)]
        [string]
        $UserId
    )
    [collections.arraylist] $folders = @("root")
    [collections.arraylist] $files = @()
    while ($folders.Length -gt 1) {
        $folder = $folders[0]
        $folders.RemoveAt(0)
        if ($null -eq $folder ) { continue }
        $objects = get-folderItems -UserId $userId -FolderId $folder
        $files += $objects | Where-Object { $null -eq $_.PSObject.Properties["folder"] }
        $newFolders = $objects | Where-Object { $null -ne $_.PSObject.Properties["folder"] -and $_.folder.childCount -gt 0 }
        # Write-Output "$newFolders.name, " # todo add progress bar
        $folders += $newFolders.id
    }
    return $files
}

get-userFiles -UserId $userId | Select-Object -Property "id", "name", "size", "webUrl"