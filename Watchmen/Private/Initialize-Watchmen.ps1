function Initialize-Watchmen {
    [cmdletbinding()]
    param()

    Write-Verbose 'Initializing Watchmen config'
    Remove-Variable -Name Watchmen -Scope Global -ErrorAction Ignore

    $defaultNotifierCondition = 'OnFailure'

    $script:Watchmen = [pscustomobject]@{
        PSTypeName = 'Watchmen.State'
        CurrentTestSetId = 0
        InConfig = $false
        InTest = $false
        InNotifies = $false
        CurrentWatchmenFileRoot = $null
        Options = [pscustomobject]@{
            PSTypeName = 'Watchmen.Config'
            NotifierConditions = @{
                WatchmenOptions = $defaultNotifierCondition
                WatchmenTest = $defaultNotifierCondition
            }
            Notifiers = [ordered]@{
                Email = @()
                EventLog = @()
                LogFile = @()
                PowerShell = @()
                Slack = @()
                Syslog = @()
            }
            Rorschach = [pscustomobject]@{
                Endpoint = $null
                Credential = $null
            }
            #NotifierOptions = @{}
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

    Write-Verbose "NotifierConditions initialized:`n$($script:watchmen.Options.NotifierConditions | Format-Table -Property * | Out-String)"
}