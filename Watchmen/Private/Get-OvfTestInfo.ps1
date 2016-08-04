function Get-OvfTestInfo {
    [cmdletbinding()]
    param(
        [parameter(Mandatory)]
        $Test
    )

    $params = @{
        ModuleName = $Test.ModuleName
        Verbose = $false
    }

    # Optionally get a test type
    if ($Test.Type -eq 'Simple' -or $Test.Type -eq 'Comprehensive') {
        $params.TestType = $Test.Type
    }

    if ($null -ne $Test.Version) {
        $params.Version = $Test.Version
    }

    Write-Debug -Message "Attempting to find OVF module [$($params.ModuleName)] with version [$($params.Version)]."
    $ovfTestInfo = GetOperationValidation @params
    if (-not $ovfTestInfo) {
        Write-Warning -Message "OVF module [$($params.ModuleName)] with version [$($params.Version)] not found in PSModulePath."
        if ($Test.source) {
            $foundModule = Install-OvfModule -Test $Test
            if ($foundModule) {
                $ovfTestInfo = GetOperationValidation -ModuleName $Test.ModuleName
            }
        } else {
            if ($null -ne $Test.Version) {
                Write-Error -Message "Unable to find OVF module [$($Test.ModuleName)] version [$($Test.Version)] and no PowerShell repository has been specified to download it from."
            } else {
                Write-Error -Message "Unable to find OVF module [$($Test.ModuleName)] and no PowerShell repository has been specified to download it from."
            }
            
        }
    }
    return $ovfTestInfo
}