$UserPrincipalName = $datasource.selectedUser.UserPrincipalName
Write-information "Searching AD user [$userPrincipalName]"
 
try {
    $adUser = Get-ADuser -Filter { UserPrincipalName -eq $userPrincipalName } -Properties AccountExpirationDate | Select AccountExpirationDate
    Write-information "Found AD user [$userPrincipalName]"
     
    $expDate = $adUser.AccountExpirationDate
    Write-information "dateset: $expDate"
     
    if([String]::IsNullOrEmpty($expDate) -eq $true) {
        $expireDateSet = $False         
    } else {
        $expireDateSet = $True
    }
     
    Write-information "Account AccountExpirationDate: $expireDateSet"     
    Write-output @{ expireDateSet = $expireDateSet }
} catch {
    Write-error "Error retrieving AD user [$userPrincipalName] account status. Error: $($_.Exception.Message)"
    return
}
