function Notifies {
    param(
        [parameter(Mandatory, Position = 0)]
        [scriptblock]$Script,

        [ValidateSet('Always', 'OnSuccess', 'OnFailure')]
        [string]$When = $global:Watchmen.Options.NotifierConditions.WatchmenOptions
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
        $global:Watchmen.InNotifies = $true

        if ($global:Watchmen.InConfig) {
            # If a specific notifier condition is provided, set that in options so subsequent notifiers will inherit the condition
            $global:Watchmen.Options.NotifierConditions.WatchmenOptions = $When

            Write-Verbose "Default Notifier condition for WatchmenOptions set to $When"

        } elseif ($global:Watchmen.InTest) {
            # If a specific notifier condition is provided, set that in options so subsequent notifiers within this WatchmenTest
            # block will inherit the condition
            $global:Watchmen.Options.NotifierConditions.WatchmenTest = $When

            Write-Verbose "Default Notifier condition for WatchmenTest set to $When"
        }
    }

    process {
        if ($global:Watchmen.InConfig) {        
            # Add all the notifiers to the Watchmen variable for later use
            Write-Debug -Message 'Adding notifiers to $global:Watchmen.Options.Notifiers'
            $notifiers = . $script
            foreach ($notifier in $notifiers) {
                $global:Watchmen.Options.Notifiers.($Notifier.Type) += $Notifier
            }
        } elseif ($global:Watchmen.InTest) {
            # Add locally defined notifiers to the test
            Write-Debug -Message 'Adding notifiers to $global:Watchmen.ThisTest.Notifiers'
            $notifiers = . $script
            foreach ($notifier in $notifiers) {
                $global:Watchmen.ThisTest.Notifiers.($Notifier.Type) += $Notifier
            }
        }
    }

    end {
        $global:Watchmen.InNotifies = $false
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
