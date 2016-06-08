function Invoke-WatchmenTest {
    [cmdletbinding(DefaultParameterSetName = 'File')]
    param(
        [parameter(ParameterSetName = 'File', Mandatory, ValueFromPipeline)]
        [string[]]$Path,
        
        [parameter(ParameterSetName = 'InputObject', Mandatory, ValueFromPipeline)]
        [pscustomobject[]]$InputObject
    )
    
    begin {
        $tests = @()
    }
    
    process {
        
        if ($PSCmdlet.ParameterSetName -eq 'File') {
            foreach ($script in $Path) {
                $tests += Get-WatchmenTest -Path $script
            }    
        } else {
            $tests = $InputObject
        }
        
        foreach ($test in $tests) {
            #$tests = Get-WatchmenTest -Path $script
            
            #foreach ($item in $tests) {
                Write-Verbose -Message "Invoking test [$($test.ModuleName)]"    
            #}
        }
    }
    
    end {}
}