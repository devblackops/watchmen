function Test {
    [cmdletbinding()]
    param(
        [string]$Test = '*'
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
    }

    process {
        $script:watchmen.ThisTest.Test = $Test
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
