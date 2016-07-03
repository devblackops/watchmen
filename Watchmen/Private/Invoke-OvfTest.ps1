function Invoke-OvfTest {
    [cmdletbinding()]
    param(
        [parameter(Mandatory, ValueFromPipeline)]
        [pscustomobject[]]$OvfTestInfo,

        [parameter(Mandatory)]
        $Test
    )

    begin { }

    process {
        foreach ($ovfTest in $OvfTestInfo) {
            Write-Verbose -Message "Running OVF test [$($Test.ModuleName)][$($ovfTest.Name)]"
            $params = @{
                TestInfo = $ovfTest
                IncludePesterOutput = $IncludePesterOutput
                Verbose = $false
            }

            if ($ovfTest.ScriptParameters) {
                if ($Test.Parameters) {
                    Write-Debug "Overriding OVF test with parameters:"
                    Write-Debug ($Test.Parameters | fl * | out-string)
                    $params.Overrides = $Test.Parameters
                }
            }
            return (Invoke-OperationValidation @params)
        }
    }

    end {}
}