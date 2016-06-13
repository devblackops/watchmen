function Invoke-WatchmenTest {
    [cmdletbinding(DefaultParameterSetName = 'File')]
    param(
        [parameter(ParameterSetName = 'File', Mandatory, ValueFromPipeline)]
        [string[]]$Path,

        [parameter(ParameterSetName = 'File')]
        [switch]$Recurse,
        
        [parameter(ParameterSetName = 'InputObject', Mandatory, ValueFromPipeline)]
        [pscustomobject[]]$InputObject,

        [switch]$IncludePesterOutput
    )
    
    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        $tests = @()
    }
    
    process {
        
        # Get the watchmen tests from file if a path to a test script or folder was passed in
        if ($PSCmdlet.ParameterSetName -eq 'File') {
            foreach ($script in $Path) {
                $tests += Get-WatchmenTest -Path $script -Recurse:$Recurse
            }    
        } else {
            $tests = $InputObject.Tests
        }
        
        foreach ($test in $tests) {
            $ovfModule = Get-OperationValidation -ModuleName $test.ModuleName
            if (-not $ovfModule) {
                if ($test.fromSource) {
                    Write-Verbose -Message "Attemping to retrieve module from repository [$($test.FromSource)]"
                    $ovfModule = Get-OperationValidation -ModuleName $test.ModuleName
                } else {
                    Write-Error -Message "Unable to find OVF module [$($test.ModuleName)]"
                }
            }
            
            # Execute the OVF test
            if ($ovfModule) {
                Write-Verbose -Message "Invoking OVF test [$($test.ModuleName)]"
                $params = @{
                    TestInfo = $ovfModule
                    IncludePesterOutput = $IncludePesterOutput   
                }
                if ($ovfModule.ScriptParameters) {
                    if ($test.Parameters) {
                        Write-Verbose "Overriding OVF test with parameters:"
                        Write-Verbose ($test.Parameters | fl * | out-string)
                        $params.Overrides = $test.Parameters
                    }
                }             
                $results = Invoke-OperationValidation @params

                # Search the OperationValidation results for any failures
                # If any are found, execute the 'Notifiers' in the Watchmen test
                if ('failed' -in $results.Result) {

                    # TODO
                    # Act on any errors from the notifiers
                    $notifierResults = Invoke-WatchmenNotifier -TestResult $results -WatchmenTest $test

                }

                # TODO
                # If we have a Rorschach endpoint defined, send the results to it

                $results
            }
        }
    }
    
    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}