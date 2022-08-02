$UserPrincipalName = $datasource.selectedUser.UserPrincipalName
Write-information "Searching AD user [$userPrincipalName]"
 
try {
    $adUser = Get-ADuser -Filter { UserPrincipalName -eq $userPrincipalName } -Properties AccountExpirationDate | Select AccountExpirationDate
    Write-information "Found AD user [$userPrincipalName]"

    #Default date for datetime selector 
    $expDate = Get-Date -Format s     
     
    if(-not [String]::IsNullOrEmpty($($adUser.AccountExpirationDate))) {
        $expDate = Get-Date $($adUser.AccountExpirationDate) -Format s        
    }
    
    Write-output @{ expireDate = "$expDate" }
    
    Write-information "Account AccountExpirationDate: $expDate"  
} catch {
    Write-error "Error retrieving AD user [$userPrincipalName] account status. Error: $($_.Exception.Message)" -Event Error     
    return
}
