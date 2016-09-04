function Notifies {
    param(
        [parameter(Mandatory, Position = 0)]
        [scriptblock]$Script,

        [ValidateSet('Always', 'OnSuccess', 'OnFailure')]
        [string]$When = $script:Watchmen.Options.NotifierConditions.WatchmenOptions
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
        $script:Watchmen.InNotifies = $true

        if ($script:Watchmen.InConfig) {
            # If a specific notifier condition is provided, set that in options so subsequent notifiers will inherit the condition
            $script:Watchmen.Options.NotifierConditions.WatchmenOptions = $When

            Write-Verbose "Default Notifier condition for WatchmenOptions set to $When"

        } elseif ($script:Watchmen.InTest) {
            # If a specific notifier condition is provided, set that in options so subsequent notifiers within this WatchmenTest
            # block will inherit the condition
            $script:Watchmen.Options.NotifierConditions.WatchmenTest = $When

            Write-Verbose "Default Notifier condition for WatchmenTest set to $When"
        }
    }

    process {
        if ($script:Watchmen.InConfig) {        
            # Add all the notifiers to the Watchmen variable for later use
            Write-Debug -Message 'Adding notifiers to $script:Watchmen.Options.Notifiers'
            $notifiers = . $script
            foreach ($notifier in $notifiers) {
                $script:Watchmen.Options.Notifiers.($Notifier.Type) += $Notifier
            }
        } elseif ($script:Watchmen.InTest) {
            # Add locally defined notifiers to the test
            Write-Debug -Message 'Adding notifiers to $script:Watchmen.ThisTest.Notifiers'
            $notifiers = . $script
            foreach ($notifier in $notifiers) {
                $script:Watchmen.ThisTest.Notifiers.($Notifier.Type) += $Notifier
            }
        }
    }

    end {
        $script:Watchmen.InNotifies = $false
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
