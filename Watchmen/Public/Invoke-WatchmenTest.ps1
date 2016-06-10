function Invoke-WatchmenTest {
    [cmdletbinding(DefaultParameterSetName = 'File')]
    param(
        [parameter(ParameterSetName = 'File', Mandatory, ValueFromPipeline)]
        [string[]]$Path,
        
        [parameter(ParameterSetName = 'InputObject', Mandatory, ValueFromPipeline)]
        [pscustomobject[]]$InputObject,

        [switch]$IncludePesterOutput
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
            $ovfModule = Get-OperationValidation -ModuleName $test.ModuleName
            if (-not $ovfModule) {
                if ($test.fromSource) {
                    Write-Verbose -Message "Attemping to retrieve module for Repository [$($test.FromSource)]"
                    $ovfModule = Get-OperationValidation -ModuleName $test.ModuleName
                } else {
                    Write-Error -Message "Unable to find OVF module [$($test.ModuleName)]"
                }
            }
            
            if ($ovfModule) {
                Write-Verbose -Message "Invoking test [$($test.ModuleName)]"

                $params = @{
                    TestInfo = $ovfModule
                    IncludePesterOutput = $IncludePesterOutput   
                }

                if ($ovfModule.ScriptParameters) {
                    #Write-Verbose "OVF test has parameters we can override!"
                    if ($test.Parameters) {
                        Write-Verbose "Overriding OVF test with parameters:"
                        Write-Verbose ($test.Parameters | fl * | out-string)
                        $params.Overrides = $test.Parameters
                    }
                }             
                
                #$results = $ovfModule | Invoke-OperationValidation -IncludePesterOutput:$IncludePesterOutput -overrides
                $results = Invoke-OperationValidation @params
                $results
            }
        }
    }
    
    end {}
}