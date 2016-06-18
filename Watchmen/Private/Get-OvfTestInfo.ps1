function Get-OvfTestInfo {
    [cmdletbinding()]
    param(
        [parameter(Mandatory)]
        $Test
    )

    $params = @{
        ModuleName = $Test.ModuleName
    }

    # Optionally get a test type 
    if ($Test.Type -eq 'Simple' -or $Test.Type -eq 'Comprehensive') {
        $params.TestType = $Test.Type
    }
    
    $ovfTestInfo = Get-OperationValidation @params
    if (-not $ovfTestInfo) {
        if ($Test.source) {
            $foundModule = Install-OvfModule -Test $Test
            if ($foundModule) {                        
                $ovfTestInfo = Get-OperationValidation -ModuleName $Test.ModuleName
            }
        } else {
            Write-Error -Message "Unable to find OVF module [$($Test.ModuleName)]"
        }
    }
    return $ovfTestInfo
}