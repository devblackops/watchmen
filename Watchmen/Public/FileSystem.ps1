function FileSystem {
    [cmdletbinding()]
    param(
        [parameter(Mandatory, Position = 0)]
        [string[]]$Path
    )
    
    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
    }

    process {
        $e = [pscustomobject]@{
            PSTypeName = 'Watchmen.Notifier.FileSystem'
            Type = 'FileSystem'
            Name = $Path
            Path = $Path
            Enabled = $true
        }       
        
        return $e
    }
    
    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }    
}
