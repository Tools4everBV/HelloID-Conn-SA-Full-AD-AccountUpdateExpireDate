$UserPrincipalName = $formInput.selectedUser.UserPrincipalName
HID-Write-Status -Message "Searching AD user [$userPrincipalName]" -Event Information
 
try {
    $adUser = Get-ADuser -Filter { UserPrincipalName -eq $userPrincipalName } -Properties AccountExpirationDate | Select-Object AccountExpirationDate
    HID-Write-Status -Message "Finished searching AD user [$userPrincipalName]" -Event Information
    HID-Write-Summary -Message "Found AD user [$userPrincipalName]" -Event Information
     
    $expDate = $adUser.AccountExpirationDate
    HID-Write-Status -Message "dateset: $expDate" -Event Information
     
    if([String]::IsNullOrEmpty($expDate) -eq $true) {
        $expireDateSet = $False
         
    } else {
        $expireDateSet = $True
    }
     
    Hid-Write-Status -Message "Account AccountExpirationDate: $expireDateSet" -Event Information
    HID-Write-Summary -Message "Account AccountExpirationDate: $expireDateSet" -Event Information
     
    Hid-Add-TaskResult -ResultValue @{ expireDateSet = $expireDateSet }
} catch {
    HID-Write-Status -Message "Error retrieving AD user [$userPrincipalName] account status. Error: $($_.Exception.Message)" -Event Error
    HID-Write-Summary -Message "Error retrieving AD user [$userPrincipalName] account status" -Event Failed
     
    Hid-Add-TaskResult -ResultValue []
}