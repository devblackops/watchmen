function EventLog {
    [cmdletbinding(DefaultParameterSetName = 'eventlog')]   
    param(
        [parameter(Mandatory, Position = 0, ParameterSetName = 'bool')]
        [bool]$Enable,

        [parameter(Mandatory, Position = 0, ParameterSetName = 'eventlog')]
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
            EventType = 'Error'
            EventId = 1
        }

        if ($PSCmdlet.ParameterSetName -eq 'bool') {
            # We were only passed a [bool] to enable/disable the event log notifiaction so we're assuming
            # somewhere before this we have specifed additional event log parameters inside a WatchmenOptions
            # block. Merge in those values

            if ($global.Watchmen.Config.NotifierOptions.EventLog) {
                $e.EventType = $global:Watchmen.Config.NotifierOptions.EventLog.EventType
                $e.EventId = $global:Watchmen.Config.NotifierOptions.EventLog.EventId
            } else {
                throw 'No event log options have been specified in WatchmenOptions!'
            }
        } else {
            Write-Debug -Message 'Event log options specified'
            $e.EventType = $Options.EventType
            $e.EventId = $Options.EventId            

            # If 'EventLog' was called from inside WatchmenOptions, then persist these settings
            # in the watchmen state for future reference
            if ($global:Watchmen.InConfig) {
                $global:Watchmen.Config.NotifierOptions.EvenLog = $e
            }    
        }

        return $e
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
