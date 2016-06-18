function Install-OvfModule {
    [cmdletbinding()]
    param(
        [parameter(Mandatory)]
        $Test
    )

    Write-Verbose -Message "Attemping to retrieve module from repository [$($Test.Source)]"

    if ($Test.Version) {
        $foundModule = Find-Module -Name $Test.ModuleName -Repository $Test.Source -MinimumVersion $Test.Version -MaximumVersion $Test.Version -ErrorAction SilentlyContinue
    } else {
        $foundModule = Find-Module -Name $Test.ModuleName -Repository $Test.Source -ErrorAction SilentlyContinue
    }
    
    if ($foundModule) {

        Write-Verbose -Message "Installing module [$($Test.ModuleName)] from [$($Test.Source)]"
        try {
            $foundModule | Install-Module -Confirm:$false -ErrorAction Stop
            return $foundModule
        } catch {
            throw "Unable to install module [$($Test.ModuleName)]"
        }
    } else {
        Write-Error -Message "Unable to find OVF module [$($Test.ModuleName)] in repository [$($Test.Source)]"
    }
}
