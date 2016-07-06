function Notifies {
    param(
        [parameter(Mandatory, Position = 0)]
        [scriptblock]$Script
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
        $global:Watchmen.InNotifies = $true
    }

    process {
        if ($global:Watchmen.InConfig) {
            # Add all the notiiers to the Watchmen variable for later use
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
