function Invoke-WatchmenTest {
    [cmdletbinding(DefaultParameterSetName = 'File')]
    param(
        [parameter(ParameterSetName = 'File', Mandatory, ValueFromPipeline)]
        [ValidateScript({
            Test-Path -Path $_
        })]
        [string[]]$Path,

        [parameter(ParameterSetName = 'File')]
        [switch]$Recurse,

        [ValidateScript({ $_.PSObject.TypeNames[0] -eq 'Watchmen.Test' })]
        [parameter(ParameterSetName = 'InputObject', Mandatory, ValueFromPipeline)]
        [pscustomobject[]]$InputObject,

        [switch]$IncludePesterOutput,

        [switch]$PassThru,

        [switch]$DisableNotifiers
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        $tests = @()

        $finalResults = @()
    }

    process {

        # Get the watchmen tests from file if a path to a test script or folder was passed in
        if ($PSCmdlet.ParameterSetName -eq 'File') {
            foreach ($script in $Path) {
                $tests += Get-WatchmenTest -Path $script -Recurse:$Recurse
            }
        } else {
            $tests = $InputObject
        }

        foreach ($test in $tests) {

            # Resolve the OVF test info and install module if needed
            $ovfTestInfo = Get-OvfTestInfo -Test $test

            if ($ovfTestInfo) {

                # Optionally filter the tests by name
                if ($test.Test) {
                    $filtered = $ovfTestInfo | where Name -like $test.Test
                }

                # Execute the OVF test
                $testResults = $filtered | Invoke-OvfTest -Test $test
                $finalResults += $testResults

                foreach ($result in $testResults) {
                    if ($result.Result -eq 'Failed') {
                        Write-Warning -Message "Failed: $($result.Name)"
                    } else {
                        Write-Verbose -Message "Passed: $($result.Name)"
                    }
                }

                #if (@($testResults | Where Result -eq 'Failed').Count -gt 0) {
                #    foreach ($failedTest in $testResults | Where Result -eq 'Failed') {
                #        Write-Warning -Message "Failed: $($failedTest.Name)" 
                #    }
                #}

                # Call notifiers on any failures unless told not to
                if (-not $PSBoundParameters.ContainsKey('DisableNotifiers')) {
                    $failedTests = @($testResults | ? {'Failed' -in $_.Result})
                    if ($failedTests.Count -gt 0) {
                        Invoke-WatchmenNotifier -TestResults $failedTests -WatchmenTest $test
                    }
                }

                # TODO
                # If we have a Rorschach endpoint defined, send the results to it

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    $testResults
                }
            }
        }
    }

    end {
        $pass = @($finalResults | Where Result -eq 'Passed').Count
        $fail = @($finalResults | Where Result -eq 'Failed').Count
        Write-Verbose -Message "Test results: Passed [$Pass] -- Failed [$fail]"
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
