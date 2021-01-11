try {
    $adUser = Get-ADuser -Filter { UserPrincipalName -eq $userPrincipalName }
    HID-Write-Status -Message "Found AD user [$userPrincipalName]" -Event Information
    HID-Write-Summary -Message "Found AD user [$userPrincipalName]" -Event Information
} catch {
    HID-Write-Status -Message "Could not find AD user [$userPrincipalName]. Error: $($_.Exception.Message)" -Event Error
    HID-Write-Summary -Message "Failed to find AD user [$userPrincipalName]" -Event Failed
}
 
try {
    if($blnexpdate -ne 'true'){
        $expDate = $null
    } else {
        $expDate = [Datetime]$expiredate
        $expDate = $expDate.AddDays(1)
    }
 
    Set-ADAccountExpiration -Identity $adUser -DateTime $expDate
     
    HID-Write-Status -Message "Finished update attribute [expireDate] of AD user [$userPrincipalName] to [$expDate]" -Event Success
    HID-Write-Summary -Message "Successfully updated attribute [expireDate] of AD user [$userPrincipalName] to [$expDate]" -Event Success
} catch {
    HID-Write-Status -Message "Could not update attribute [expireDate] of AD user [$userPrincipalName] to [$expDate]. Error: $($_.Exception.Message)" -Event Error
    HID-Write-Summary -Message "Failed to update attribute [expireDate] of AD user [$userPrincipalName] to [$expDate]" -Event Failed
}
