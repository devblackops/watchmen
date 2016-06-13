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

        #Write-Verbose -Message "Current Watchmen Test set ID is $($global:Watchmen.CurrentTestSetId)"

        # Initialize Watchmen config if an 'OvfSetup' function hasn't been executed yet
        if ($null -eq $global:Watchmen) {
            #Initialize-Watchmen        
        }

        # Mark that we are inside an 'WatchmenTest' block and subsequent commands are allowed
        $global:Watchmen.InTest = $true
    }

    process {

        $script:ThisWatchmenTest = @{
            PSTypeName = 'Watchmen.Test'
            ModuleName = $Name
            parameters = @{}
            Source = $null        
            Test = '*'
            Type = 'all'        
            Version = $null
            Notifiers = @()
        }

        # Execute any functions passed in        
        . $Script

        # Add any Notifiers that were defined in WatchmenOptions
        $script:ThisWatchmenTest.Notifiers += $global:Watchmen.Config.Notifiers

        # Add any Notifiers to the test
        $script:ThisWatchmenTest.Notifiers += $global:ThisNotifiers

        $t = [pscustomobject]$script:ThisWatchmenTest
        Write-Verbose -Message "Created Watchmen test [$($t.ModuleName)[$($t.Test)]]"

        Remove-Variable -Name ThisWatchmenTest -Scope Script       

        return $t
    }

    end {
        # Increment TestSet ID so our tests will be placed in a new set
        #$global:Watchmen.CurrentTestSetId += 1
        #Write-Verbose -Message "Next Watchmen Test set ID is $($global:Watchmen.CurrentTestSetId)"

        # Mark that we have exited the 'WatchmenTest' block
        $global:Watchmen.InTest = $false

        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}