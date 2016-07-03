function FromSource {
    [cmdletbinding()]
    param(
        [parameter(Mandatory, Position = 0)]
        [string]$Source
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
    }

    process {
        $global:watchmen.ThisTest.Source = $Source
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
