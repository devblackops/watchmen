function WatchmenOptions {
    [cmdletbinding()]
    param(        
        [scriptblock]$Script    
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"        
        # Mark that we are inside an 'WatchmenOptions' block and subsequent commands are allowed
        $global:Watchmen.InConfig = $true
    }

    process {        
        # Execute any functions passed in
        . $Script
    }

    end {    
        # Mark that we have exited the 'WatchmenOptions' block
        $global:Watchmen.InConfig = $false
        
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
