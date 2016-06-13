function EventLog {
    [cmdletbinding()]   
    param(
        [parameter(Mandatory, Position = 0)]
        [hashtable[]]$Log
    )
    
    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
    }
    
    process {
        [pscustomobject]@{
            PSTypeName = 'Watchmen.Notifier.EventLog'
            Type = 'EventLog'
            Values = $Log | % {
                $_.PSTypeName = 'Watchmen.Notifier.EventLog.Config'
                [pscustomobject]$_
            }
        }
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
