$blnexpdate =  $form.blnExpDate
$expDate = $form.expireDate
$userPrincipalName = $form.gridUsers.UserPrincipalName

try {
    $adUser = Get-ADuser -Filter { UserPrincipalName -eq $userPrincipalName }
    Write-Information "Found AD user [$userPrincipalName]"    
} catch {
    Write-Error "Could not find AD user [$userPrincipalName]. Error: $($_.Exception.Message)"
}
 
try {
    if($blnexpdate -ne 'true'){
        $expDate = $null
    } else {
        $expDate = [Datetime]$expDate
        $expDate = $expDate.AddDays(1)
    }
    
    Set-ADAccountExpiration -Identity $adUser -DateTime $expDate
     
    Write-Information "Finished update attribute [expireDate] of AD user [$userPrincipalName] to [$expDate]"
    $Log = @{
            Action            = "UpdateAccount" # optional. ENUM (undefined = default) 
            System            = "ActiveDirectory" # optional (free format text) 
            Message           = "Successfully updated attribute [expireDate] of AD user [$userPrincipalName] to [$expDate]" # required (free format text) 
            IsError           = $false # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
            TargetDisplayName = $adUser.name # optional (free format text) 
            TargetIdentifier  = $([string]$adUser.SID) # optional (free format text) 
        }
    #send result back  
    Write-Information -Tags "Audit" -MessageData $log    
} catch {
    Write-Error "Could not update attribute [expireDate] of AD user [$userPrincipalName] to [$expDate]. Error: $($_.Exception.Message)"
    $Log = @{
            Action            = "UpdateAccount" # optional. ENUM (undefined = default) 
            System            = "ActiveDirectory" # optional (free format text) 
            Message           = "Failed to update attribute [expireDate] of AD user [$userPrincipalName] to [$expDate]" # required (free format text) 
            IsError           = $true # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
            TargetDisplayName = $adUser.name # optional (free format text) 
            TargetIdentifier  = $([string]$adUser.SID) # optional (free format text) 
        }
    #send result back  
    Write-Information -Tags "Audit" -MessageData $log    
}
