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

            $ovfTestInfo = Get-OvfTestInfo -Test $test
            
            # Execute the OVF test
            if ($ovfTestInfo) {

                # Optionally filter the tests by name
                if ($test.Test) {
                    $filtered = $ovfTestInfo | where Name -like $test.Test    
                }

                $testResults = @()                

                foreach ($ovfTest in $filtered) {
                    Write-Verbose -Message "Invoking OVF test [$($test.ModuleName)][$($ovfTest.Name)]"
                    $params = @{
                        TestInfo = $ovfTest
                        IncludePesterOutput = $IncludePesterOutput   
                    }
                
                    if ($ovfTest.ScriptParameters) {
                        if ($test.Parameters) {
                            Write-Verbose "Overriding OVF test with parameters:"
                            Write-Verbose ($test.Parameters | fl * | out-string)
                            $params.Overrides = $test.Parameters
                        }
                    }             
                    $testResults += Invoke-OperationValidation @params
                }

                # Search the OperationValidation results for any failures
                # If any are found, execute the 'Notifiers' in the Watchmen test
                if ('failed' -in $testResults.Result) {

                    # TODO
                    # Act on any errors from the notifiers
                    $notifierResults = Invoke-WatchmenNotifier -TestResult $testResults -WatchmenTest $test

                }

                # TODO
                # If we have a Rorschach endpoint defined, send the results to it

                $testResults
            } else {
                Write-Error -Message "Unable to find OVF into for module [$($Test.ModuleName)]"
            }
        }
    }
    
    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}