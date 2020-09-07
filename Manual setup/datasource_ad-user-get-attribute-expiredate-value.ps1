$UserPrincipalName = $formInput.selectedUser.UserPrincipalName
HID-Write-Status -Message "Searching AD user [$userPrincipalName]" -Event Information
 
try {
    $adUser = Get-ADuser -Filter { UserPrincipalName -eq $userPrincipalName } -Properties AccountExpirationDate | Select-Object AccountExpirationDate
    HID-Write-Status -Message "Finished searching AD user [$userPrincipalName]" -Event Information
    HID-Write-Summary -Message "Found AD user [$userPrincipalName]" -Event Information
     
    $expDate = $adUser.AccountExpirationDate
     
     
    if([String]::IsNullOrEmpty($expDate) -eq $true) {
         Hid-Add-TaskResult -ResultValue []
         
    } else {
        $expDate = Get-Date $expDate -Format s
        Hid-Add-TaskResult -ResultValue @{ expireDate = "$expDate" }
    }
     
    Hid-Write-Status -Message "Account AccountExpirationDate: $expDate" -Event Information
    HID-Write-Summary -Message "Account AccountExpirationDate: $expDate" -Event Information
     
    
} catch {
    HID-Write-Status -Message "Error retrieving AD user [$userPrincipalName] account status. Error: $($_.Exception.Message)" -Event Error
    HID-Write-Summary -Message "Error retrieving AD user [$userPrincipalName] account status" -Event Failed
     
    Hid-Add-TaskResult -ResultValue []
}