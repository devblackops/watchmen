function LogFile {
    [cmdletbinding()]
    param(
        [parameter(Mandatory, Position = 0)]
        [string[]]$Path,

        [ValidateSet('Always', 'OnSuccess', 'OnFailure')]
        [string]$When = $global:Watchmen.Options.NotifierConditions.WatchmenTest
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
    }

    process {
        $e = [pscustomobject]@{
            PSTypeName = 'Watchmen.Notifier.LogFile'
            Type = 'LogFile'
            Name = $Path
            Path = $Path
            Enabled = $true
            NotifierCondition = $When
        }

        return $e
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
