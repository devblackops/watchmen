function InvokeOperationValidation {
    <#
    .SYNOPSIS
    Invoke the operational tests from modules

    .DESCRIPTION
    Modules which include Diagnostics tests are executed via this cmdlet

    .PARAMETER testFilePath
    The path to a diagnostic test to execute. By default all discoverable diagnostics will be invoked

    .PARAMETER TestInfo
    The type of tests to invoke, this may be either "Simple", "Comprehensive"
    or Both ("Simple,Comprehensive"). "Simple,Comprehensive" is the default.

    .EXAMPLE
    PS> Get-OperationValidation -ModuleName OperationValidation | Invoke-OperationValidation -IncludePesterOutput
    Describing Simple Test Suite
    [+] first Operational test 20ms
    [+] second Operational test 19ms
    [+] third Operational test 9ms
    Tests completed in 48ms
    Passed: 3 Failed: 0 Skipped: 0 Pending: 0
    Describing Scenario targeted tests
    Context The RemoteAccess service
        [+] The service is running 37ms
    Context The Firewall Rules
        [+] A rule for TCP port 3389 is enabled 1.19s
        [+] A rule for UDP port 3389 is enabled 11ms
    Tests completed in 1.24s
    Passed: 3 Failed: 0 Skipped: 0 Pending: 0


    Module: OperationValidation

    Result  Name
    ------- --------
    Passed  Simple Test Suite::first Operational test
    Passed  Simple Test Suite::second Operational test
    Passed  Simple Test Suite::third Operational test
    Passed  Scenario targeted tests:The RemoteAccess service:The service is running
    Passed  Scenario targeted tests:The Firewall Rules:A rule for TCP port 3389 is enabled
    Passed  Scenario targeted tests:The Firewall Rules:A rule for UDP port 3389 is enabled

    .LINK
    Get-OperationValidation
    #>
    #[CmdletBinding(SupportsShouldProcess=$true,DefaultParameterSetName="FileAndTest")]
    [cmdletbinding()]
    param (
        [Parameter(ParameterSetName="Path",ValueFromPipelineByPropertyName=$true)]
        [string[]]$testFilePath,

        [Parameter(ParameterSetName="FileAndTest",ValueFromPipeline=$true)]
        [pscustomobject[]]$TestInfo,

        [Parameter(ParameterSetName="UseGetOperationTest")]
        [string[]]$ModuleName = "*",

        [Parameter(ParameterSetName="UseGetOperationTest")]
        [ValidateSet("Simple","Comprehensive")]
        [string[]]$TestType = @("Simple","Comprehensive"),

        [switch]$IncludePesterOutput,

        [Version]$Version,

        [hashtable]$Overrides
    )

    BEGIN {
        $quiet = ! $IncludePesterOutput
        if ( ! (get-module -Name Pester)) {
            if ( get-module -list Pester ) {
                import-module -Name Pester
            } else {
                Throw "Cannot load Pester module"
            }
        }
    }
    PROCESS {
        if ( $PSCmdlet.ParameterSetName -eq "UseGetOperationTest" ) {
            if ($PSBoundParameters.ContainsKey('Version')) {
                $tests = GetOperationValidation -ModuleName $ModuleName -TestType $TestType -Version $Version
            } else {
                $tests = GetOperationValidation -ModuleName $ModuleName -TestType $TestType
            }
            #$tests | InvokeOperationValidation -IncludePesterOutput:$IncludePesterOutput -Overrides $Overrides
            return
        }

        if ( ($testFilePath -eq $null) -and ($TestInfo -eq $null) ) {
            if ($PSBoundParameters.ContainsKey('Version')) {
                #GetOperationValidation -Version $Version | InvokeOperationValidation -IncludePesterOutput:$IncludePesterOutput -Overrides $Overrides
            } else {
                #GetOperationValidation | InvokeOperationValidation -IncludePesterOutput:$IncludePesterOutput -Overrides $Overrides
            }
            return
        }

        if ( $testInfo -ne $null ) {
            # first check to be sure all of the TestInfos are sane
            foreach($ti in $testinfo) {
                if ( ! ($ti.FilePath -and $ti.Name)) {
                    throw "TestInfo must contain the path and the list of tests"
                }
            }

            #Write-Verbose -Message ("EXECUTING: {0} {1}" -f $ti.FilePath,($ti.Name -join ","))
            foreach($ti in $testinfo) {

                #Write-Verbose "Test name: $tname"

                $pesterParams = @{
                    TestName = $ti.Name
                    Quiet = $quiet
                    PassThru = $true
                    Verbose = $false
                }

                if ($ti.ScriptParameters) {
                    Write-Verbose -Message "Test has script parameters"  
                    if ($PSBoundParameters.ContainsKey('Overrides')) {
                        Write-Verbose -Message "Overriding with parameters:`n$($Overrides | Format-List -Property * | Out-String)"
                        $pesterParams.Script = @{
                            Path = $ti.FilePath
                            Parameters = $Overrides
                        }
                    } else {
                        Write-Verbose -Message 'Using default parameters for test'
                        $pesterParams.Path = $ti.FilePath
                    }
                } else {
                    $pesterParams.Path = $ti.FilePath
                }

                $testResult = Invoke-Pester @pesterParams
                if ($testResult) {
                    Add-member -InputObject $testResult -MemberType NoteProperty -Name Path -Value $ti.FilePath
                    Convert-TestResult $testResult
                }
            }
            return
        }

        # foreach($test in $testFilePath) {
        #     write-progress -Activity "Invoking tests in $test"
        #     if ( $PSCmdlet.ShouldProcess($test)) {
        #         $testResult = Invoke-Pester $test -passthru -quiet:$quiet
        #         Add-Member -InputObject $testResult -MemberType NoteProperty -Name Path -Value $test
        #         Convert-TestResult $testResult
        #     }
        # }
    }
}
