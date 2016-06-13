function FileSystem {
    [cmdletbinding()]    
    param(
        [parameter(Mandatory, Position = 0)]
        [string[]]$Paths
    )
    
    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
    }

    process {
    [pscustomobject]@{
            PSTypeName = 'Watchmen.Notifier.FileSystem'
            Type = 'FileSystem'
            Values = $Paths
        }
    }
    
    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }    
}
