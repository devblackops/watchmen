function Email {
    [cmdletbinding(DefaultParameterSetName = 'emailaddress')]    
    param(
        [parameter(Mandatory, Position = 0, ParameterSetName = 'emailaddress')]
        [ValidateScript({
            if ($_ -match '^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$') {
                $true
            } else {
                throw "$_ is not a valid email address"
            }            
        })]
        [string[]]$To,

        [parameter(Mandatory, Position = 0, ParameterSetName = 'options')]
        [hashtable]$Options
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
    }

    process {
        $e = [pscustomobject]@{
            PSTypeName = 'Watchmen.Notifier.Email'
            Type = 'Email'
            FromAddress = [string]::Empty
            Subject = [string]::Empty
            SmtpServer = [string]::Empty
            Port = 25
            Credential = $null
            To = @()
        }

        if ($PSCmdlet.ParameterSetName -eq 'emailaddress') {

            # We were only passed in email address so we're assuming somewhere before this we have
            # specifed additional email parameters inside a WatchmenOptions block.
            # Merge in those values

            if ($global:Watchmen.Config.NotifierOptions.Email) {
                $e.FromAddress = $global:Watchmen.Config.NotifierOptions.Email.FromAddress
                $e.Subject = $global:Watchmen.Config.NotifierOptions.Email.Subject
                $e.SmtpServer = $global:Watchmen.Config.NotifierOptions.Email.SmtpServer
                $e.Port = $global:Watchmen.Config.NotifierOptions.Email.Port
                $e.Credential = $global:Watchmen.Config.NotifierOptions.Email.Credential
                $e.To = $To
            } else {
                throw "No email options have been specified in WatchmenOptions!"
            }
        } else {
            Write-Debug -Message 'Email options specified'
            $e.FromAddress = $Options.FromAddress
            $e.Subject = $Options.Subject
            $e.SmtpServer = $Options.SmtpServer
            $e.Port = $Options.Port
            $e.Credential = $Options.Credential
            $e.To = $Options.To

            # If 'Email' was called from inside WatchmenOptions, then persist these settings
            # in the watchmen state for future reference
            if ($global:Watchmen.InConfig) {
                $global:Watchmen.Config.NotifierOptions.Email = $e
            }
        }

        return $e
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
