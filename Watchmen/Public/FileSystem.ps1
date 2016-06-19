function FileSystem {
    [cmdletbinding(DefaultParameterSetName = 'path')]
    param(
        [parameter(Mandatory, Position = 0, ParameterSetName = 'path')]
        [string[]]$Path,

        [parameter(Mandatory, Position = 0, ParameterSetName = 'bool')]
        [bool]$Enable
    )
    
    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
    }

    process {
        $e = [pscustomobject]@{
            PSTypeName = 'Watchmen.Notifier.FileSystem'
            Type = 'FileSystem'
            Path = $Path
            Enabled = $true
        }

        if ($PSCmdlet.ParameterSetName -eq 'bool') {
            # We were only passed a [bool] to enable/disable the file system notifiaction so we're assuming
            # somewhere before this we have specifed additional file system parameters inside a WatchmenOptions
            # block. Merge in those values

            if ($global.Watchmen.Config.NotifierOptions.FileSystem) {
                $e.Path = $global:Watchmen.Config.NotifierOptions.FileSystem.Path
                if (-not $Enable) {
                    $e.Enable = $false
                }
            } else {
                throw 'No file system options have been specified in WatchmenOptions!'
            }
        } else {
            Write-Debug -Message 'File system options specified'
            $e.Path = $Path            

            # If 'Filesystem' was called from inside WatchmenOptions, then persist these settings
            # in the watchmen state for future reference
            if ($global:Watchmen.InConfig) {
                $global:Watchmen.Config.NotifierOptions.FileSystem = $e
            }
        }
        
        return $e
    }
    
    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }    
}
