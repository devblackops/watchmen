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
            Write-Host -Object "`n"
            Write-Verbose -Message "Running OVF test [$($Test.ModuleName)][$($ovfTest.Name)]"
            $params = @{
                TestInfo = $ovfTest
                IncludePesterOutput = $IncludePesterOutput
                #Verbose = $false
            }

            if ($ovfTest.ScriptParameters) {
                if ($Test.Parameters.Keys.Count -gt 0) {                    
                    $params.Overrides = $Test.Parameters
                }
            }
            return (InvokeOperationValidation @params)
        }
    }

    end {}
}