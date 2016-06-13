function Email {
    [cmdletbinding()]    
    param(
        [parameter(Mandatory, Position = 0)]
        [ValidateScript({
            if ($_ -match '^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$') {
                $true
            } else {
                throw "$_ is not a valid email address"
            }            
        })]
        [string[]]$EmailAddress
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
    }

    process {        
        return [pscustomobject]@{
            PSTypeName = 'Watchmen.Notifier.Email'
            Type = 'Email'
            Values = $EmailAddress
        }
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
