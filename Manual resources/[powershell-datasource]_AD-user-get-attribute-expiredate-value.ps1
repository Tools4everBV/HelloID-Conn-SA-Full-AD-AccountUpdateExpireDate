$UserPrincipalName = $datasource.selectedUser.UserPrincipalName
Write-information "Searching AD user [$userPrincipalName]"
 
try {
    $adUser = Get-ADuser -Filter { UserPrincipalName -eq $userPrincipalName } -Properties AccountExpirationDate | Select AccountExpirationDate
    Write-information "Found AD user [$userPrincipalName]"
     
    $expDate = $adUser.AccountExpirationDate     
     
    if(-not [String]::IsNullOrEmpty($expDate)) {
        $expDate = Get-Date $expDate -Format s
        Write-output @{ expireDate = "$expDate" }
    }
     
    Write-information "Account AccountExpirationDate: $expDate"  
} catch {
    Write-error "Error retrieving AD user [$userPrincipalName] account status. Error: $($_.Exception.Message)" -Event Error     
    return
}
