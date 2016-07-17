Function Convert-TestResult {
    param ( $result )
    foreach ( $testResult in $result.TestResult ) {
        $testError = $null
        if ( $testResult.Result -eq "Failed" ) {
            $testError = New-OperationValidationFailure -Stacktrace $testResult.StackTrace -FailureMessage $testResult.FailureMessage
        } else {
            #Write-Verbose -Message "Passed: $($testResult.Name)"
        }
        $Module = $result.Path.split([io.path]::DirectorySeparatorChar)[-4]
        $TestName = "{0}:{1}:{2}" -f $testResult.Describe,$testResult.Context,$testResult.Name
        New-OperationValidationResult -Module $Module -Name $TestName -FileName $result.path -Result $testresult.result -RawResult $testResult -Error $TestError
    }
}
