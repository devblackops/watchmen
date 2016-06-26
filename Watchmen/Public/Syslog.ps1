function Syslog {
    [cmdletbinding(DefaultParameterSetName = 'endpoint')]
    param(
        [parameter(Mandatory, Position = 0, ParameterSetName = 'endpoint')]
        [string[]]$Endpoints,

        [parameter(Mandatory, Position = 0, ParameterSetName = 'bool')]
        [bool]$Enable
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
    }

    process {
        $e = [pscustomobject]@{
            PSTypeName = 'Watchmen.Notifier.Syslog'
            Type = 'Syslog'
            Endpoint = @()
            Enabled = $true
        }

        if ($PSCmdlet.ParameterSetName -eq 'bool') {
            # We were only passed a [bool] to enable/disable the syslog notifiaction so we're assuming
            # somewhere before this we have specifed additional syslog parameters inside a WatchmenOptions
            # block. Merge in those values

            if ($global:Watchmen.Config.NotifierOpsions.Syslog) {
                $e.Endpoint = $global:Watchmen.Options.NotifierOptions.Syslog.Endpoint
                if (-not $Enable) {
                    $e.Enabled = $false
                }
            } else {
                throw 'No syslog options have been specified in WatchmenOptions!'
            }
        } else {
            Write-Debug -Message 'endpoint options specified'
            $e.Endpoint += $Endpoints
            
            # If 'Syslog' was called from inside WatchmenOptions, then persist these settings
            # in the watchmen state for future reference
            if ($global:Watchmen.InConfig) {
                $global:Watchmen.Options.NotifierOptions.Syslog = $e
            }
        }

        return $e
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
