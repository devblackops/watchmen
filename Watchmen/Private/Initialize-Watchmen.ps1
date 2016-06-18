function Initialize-Watchmen {
    [cmdletbinding()]
    param()
    
    Write-Verbose 'Initializing Watchmen config'
    Remove-Variable -Name Watchmen -Scope Global -ErrorAction Ignore
    $global:Watchmen = [pscustomobject]@{
        PSTypeName = 'Watchmen.State'
        CurrentTestSetId = 0
        InConfig = $false
        InTest = $false
        InNotifies = $false
        Config = [pscustomobject]@{
            PSTypeName = 'Watchmen.Config'
            Notifiers = @()
            Rorschach = [pscustomobject]@{
                Endpoint = $null
                Credential = $null
            }
            NotifierOptions = @{}
        }
        TestSets = @(
             [pscustomobject]@{
                 PSTypeName = 'Watchmen.TestSet'
                 ID = 0
                 Config = $null
                 Tests = @()
                 Notifiers = @{}
             }
        )
    }
}