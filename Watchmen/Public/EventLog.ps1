function EventLog {
    [cmdletbinding(DefaultParameterSetName = 'eventlog')]   
    param(
        [parameter(Mandatory, Position = 0, ParameterSetName = 'eventlog')]
        [hashtable[]]$Options,

        [parameter(Mandatory, Position = 0, ParameterSetName = 'bool')]
        [bool]$Enable
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
            Enabled = $true
        }

        if ($PSCmdlet.ParameterSetName -eq 'bool') {
            # We were only passed a [bool] to enable/disable the event log notifiaction so we're assuming
            # somewhere before this we have specifed additional event log parameters inside a WatchmenOptions
            # block. Merge in those values

            if ($global.Watchmen.Options.NotifierOptions.EventLog) {
                $e.EventType = $global:Watchmen.Options.NotifierOptions.EventLog.EventType
                $e.EventId = $global:Watchmen.Options.NotifierOptions.EventLog.EventId
                if (-not $Enable) {
                    $e.Enabled = $false
                }
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
                $global:Watchmen.Options.NotifierOptions.EvenLog = $e
            }    
        }

        return $e
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
