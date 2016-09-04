function TestType {
    param(
        [parameter(Mandatory, Position = 0)]
        [ValidateSet('Simple', 'Comprehensive', 'All')]
        [string]$Type
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
    }

    process {
        $script:watchmen.ThisTest.Type = $Type
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
