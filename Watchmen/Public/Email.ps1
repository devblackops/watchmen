function Email {
    [cmdletbinding()]
    param(
        [parameter(Mandatory, Position = 0)]
        [hashtable]$Options,

        [ValidateSet('Always', 'OnSuccess', 'OnFailure')]
        [string]$When = $script:Watchmen.Options.NotifierConditions.WatchmenTest
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
    }

    process {
        $e = [pscustomobject]@{
            PSTypeName = 'Watchmen.Notifier.Email'
            Type = 'Email'
            Name = $Options.Name
            FromAddress = $Options.FromAddress
            Subject = $Options.Subject
            Message = $Options.Message
            SmtpServer = $Options.SmtpServer
            Port = $Options.Port
            Credential = $Options.Credential
            UseSSL = $Options.UseSSL
            To = $Options.To
            Enabled = $true
            NotifierCondition = $When
        }

        return $e
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
