function WatchmenTest {
    [cmdletbinding(DefaultParameterSetName = 'NoName')]
    param(
        [parameter( ParameterSetName = 'Name', Position = 0)]
        [string]$Name = (New-Guid).ToString(),

        [parameter( ParameterSetName = 'Name', Position = 1, Mandatory = $True)]
        [parameter( ParameterSetName = 'NoName', Position = 0, Mandatory = $True)]
        [scriptblock]$Script
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"

        # Mark that we are inside an 'WatchmenTest' block and subsequent commands are allowed
        $global:Watchmen.InTest = $true

        # Set the default value for the notifier conditions to what ever has been set in WatchmenOptions
        # If nothing was specified there, this value will be 'OnFailure'
        $defaultNotifierCondition = $global:Watchmen.Options.NotifierConditions.WatchmenOptions
        $global:Watchmen.Options.NotifierConditions.WatchmenTest = $defaultNotifierCondition

        $global:Watchmen.ThisTest = @{
            PSTypeName = 'Watchmen.Test'
            ModuleName = $Name
            parameters = @{}
            Source = $null
            Test = '*'
            Type = 'all'
            Version = $null
            Notifiers = [ordered]@{
                Email = @()
                EventLog = @()
                LogFile = @()
                PowerShell = @()
                Slack = @()
                Syslog = @()
            }
        }
    }

    process {        

        # Execute any functions passed in
        . $Script

        # Add any global notifiers to the test
        foreach ($key in $global:Watchmen.Options.Notifiers.Keys) {
            $globalNotifier = $global:Watchmen.Options.Notifiers.($key)
            if ($globalNotifier.Count -gt 0) {
                $global:Watchmen.ThisTest.Notifiers.($key) += $globalNotifier
            }
        }

        $t = [pscustomobject]$global:watchmen.ThisTest
        Write-Verbose -Message "Created Watchmen test [$($t.ModuleName)[$($t.Test)]]"

        return $t
    }

    end {
        # Mark that we have exited the 'WatchmenTest' block
        $global:Watchmen.InTest = $false

        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
