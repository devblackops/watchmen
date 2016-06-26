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
            Write-Debug -Message 'Adding notifiers to $global:Watchmen.Options.Notifiers'
            $global:Watchmen.Options.Notifiers += . $script
        } elseif ($global:Watchmen.InTest) {
            Write-Debug -Message 'Adding notifiers to $global:Watchmen.ThisTest.Notifiers'
            $global:Watchmen.ThisTest.Notifiers += . $script      
        }  
    }

    end {
        $global:Watchmen.InNotifies = $false
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }    
}
