function Get-WatchmenTest {
    [cmdletbinding()]
    param(
        [string[]]$Path
    )
    
    begin {
        $script:TestsToExecute = @()
    }
    
    process {
        foreach ($script in $path) {
            $script:TestsToExecute += . $script
        }
    }
    
    end {
        return $script:TestsToExecute
    }
}