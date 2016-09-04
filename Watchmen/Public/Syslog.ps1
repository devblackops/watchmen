function Syslog {
    [cmdletbinding()]
    param(
        [parameter(Mandatory, Position = 0)]
        [string[]]$Endpoints,

        [ValidateSet('Always', 'OnSuccess', 'OnFailure')]
        [string]$When = $script:Watchmen.Options.NotifierConditions.WatchmenTest
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
    }

    process {
        $e = [pscustomobject]@{
            PSTypeName = 'Watchmen.Notifier.Syslog'
            Type = 'Syslog' 
            Endpoints = $Endpoints
            Enabled = $true
            NotifierCondition = $When
        }

        return $e
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
