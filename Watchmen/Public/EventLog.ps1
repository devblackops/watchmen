function EventLog {
    [cmdletbinding()]   
    param(
        [parameter(Mandatory, Position = 0)]
        [hashtable[]]$Options
    )
    
    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
    }
    
    process {
        $e = [pscustomobject]@{
            PSTypeName = 'Watchmen.Notifier.EventLog'
            Type = 'EventLog'
            Name = $Options.Name
            EventType = $Options.EventType
            EventId = $Options.EventId
            Enabled = $true
        }

        return $e
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
