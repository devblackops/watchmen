function Rorschach {
    param(
        [parameter(Mandatory, Position = 0)]
        [hashtable[]]$Settings
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
    }

    process {
        $global:ThisRorschach = [pscustomobject]@{
            PSTypeName = 'Watchmen.Rorschach'
            Endpoint = $Settings.Endpoint
            Credendial = $Settings.Credential
        }
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }    
}
