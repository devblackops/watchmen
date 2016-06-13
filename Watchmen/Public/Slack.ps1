function Slack {    
    param(
        [parameter(Mandatory, Position = 0)]
        [hashtable[]]$SlackConfig
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
    }

    process {
        [pscustomobject]@{
            PSTypeName = 'Watchmen.Notifier.Slack'
            Type = 'Slack'
            Values = $SlackConfig | % {
                $_.PSTypeName = 'Watchmen.Notifier.Slack.Config'
                [pscustomobject]$_
            }
        }
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
