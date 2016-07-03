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
        Options = [pscustomobject]@{
            PSTypeName = 'Watchmen.Config'
            #Notifiers = @()
            Notifiers = @{
                Email = @()
                EventLog = @()
                LogFile = @()
                Slack = @()
                Syslog = @()
            }
            Rorschach = [pscustomobject]@{
                Endpoint = $null
                Credential = $null
            }
            NotifierOptions = @{}
        }
        ThisTest = $null
        TestSets = @(
             [pscustomobject]@{
                 PSTypeName = 'Watchmen.TestSet'
                 ID = 0
                 Options = $null
                 Tests = @()
                 Notifiers = @{}
             }
        )
    }
}