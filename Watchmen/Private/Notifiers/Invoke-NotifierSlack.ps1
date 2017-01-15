#requires -modules PSSlack

function Invoke-NotifierSlack {
    [cmdletbinding()]
    param(
        [parameter(Mandatory, ValueFromPipeline)]
        [ValidateScript({ $_.PSObject.TypeNames[0] -eq 'Watchmen.Notifier.Slack' })]
        [pscustomobject]$Notifier,

        [parameter(Mandatory)]
        [ValidateScript({ $_.PSObject.TypeNames[0] -eq 'OperationValidationResult' })]
        [pscustomobject]$Results
    )

    if ($Notifier.Enabled) {
        Import-Module -Name PSSlack -Verbose:$false -ErrorAction Stop

        $o = ($Notifier | Format-Table -Property * -AutoSize | Out-String)
        Write-Debug -Message "Slack notifier called with options:`n$o"

        $text = @"
Watchmen reported a failure in OVF test:

Computer: $env:COMPUTERNAME

Module: $($results.Module)

File: $($results.FileName)

Describe: $($results.RawResult.Describe)

Context: $($results.RawResult.Context)

Test: $($results.RawResult.Name)

Result: $($results.Result)

Message: $($results.RawResult.FailureMessage)

Duration: $($results.RawResult.Time.ToString())
"@

        $fields = @(
            @{title = 'Computer'; value = $env:COMPUTERNAME; short = $true }
            @{title = 'Module'; value = $results.Module; short = $true }
            @{title = 'Test'; value = $results.RawResult.Name; short = $false }
            @{title = 'Describe'; value = $results.RawResult.Describe; short = $true }
            @{title = 'Context'; value = $results.RawResult.Context; short = $true }
            @{title = 'File'; value = $results.FileName; short = $false }
            @{title = 'Result'; value = $results.Result; short = $true }
            @{title = 'Message'; value = $results.RawResult.FailureMessage; short = $true }
            @{title = 'Duration'; value = $results.RawResult.Time.ToString(); short = $true }
        )

        if ($null -ne $Notifier.PreText -and $Notifier.PreText -ne [string]::Empty) {
            $pretext = $Notifier.PreText
        } else {
            $pretext = 'Failed Watchmen Test'
        }

        $params = @{
            Color = [System.Drawing.Color]::Red
            Title = "$($Notifier.IconEmoji) $($results.Result.ToUpper()) - $($results.RawResult.Name)"
            Fields = $fields
            PreText = $pretext
            AuthorName = $Notifier.AuthorName
            Fallback = $text
        }
        $att = New-SlackMessageAttachment @params
        if ($Notifier.IconEmoji -ne [string]::Empty) {
            $msg = $att | New-SlackMessage -Channel $Notifier.Channel -IconEmoji $Notifier.IconEmoji
        } else {
            $msg = $att | New-SlackMessage -Channel $Notifier.Channel -IconUrl $Notifier.IconUrl
        }
        $msg | Send-SlackMessage -Uri $Notifier.Token | Out-Null
    }
}
