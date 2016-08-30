function When {
    param(
        [parameter(Mandatory, Position = 0)]
        [ValidateSet('Always', 'OnSuccess', 'OnFailure')]
        [string]$Condition
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
    }

    process {
        if ($global:watchmen.InConfig) {
            $global:watchmen.Options.NotifierConditions.WatchmenOptions = $Condition
            $global:watchmen.Options.NotifierConditions.WatchmenTest = $Condition

            Write-Verbose "WatchmenOptions default notifier condition set to $Condition"

        } elseIf ($global:watchmen.InTest) {
            $global:watchmen.Options.NotifierConditions.WatchmenTest = $Condition

            Write-Verbose "WatchmenTest default notifier condition set to $Condition"
        }        
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
