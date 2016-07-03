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

Descibe:  $($results.RawResult.Describe)

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
            @{title = 'Descibe'; value = $results.RawResult.Describe; short = $true }
            @{title = 'Context'; value = $results.RawResult.Context; short = $true }
            @{title = 'File'; value = $results.FileName; short = $false }
            @{title = 'Result'; value = $results.Result; short = $true }
            @{title = 'Message'; value = $results.RawResult.FailureMessage; short = $true }
            @{title = 'Duration'; value = $results.RawResult.Time.ToString(); short = $true }
        )

        $params = @{
            Color = ([System.Drawing.Color]::Red)
            Title = "$($Notifer.IconEmoji) $($env:COMPUTERNAME) - $($results.Result.ToUpper()) - $($results.RawResult.Name)"
            #Title = "Test details:"
            TitleLink = $Notifier.TitleLink
            Fields = $fields
            PreText = "Failed Watchmen Test"
            AuthorName = $Notifier.AuthorName
            Fallback = $text
        }
        $att = New-SlackMessageAttachment @params
        if ($Notifier.IconEmoji -ne [string]::Empty) {
            $msg = $att | New-SlackMessage -Channel $Notifer.Channel -IconEmoji $Notifier.IconEmoji
        } else {
            $msg = $att | New-SlackMessage -Channel $Notifer.Channel -IconUrl $Notifier.IconUrl
        }
        $msg | Send-SlackMessage -Uri $Notifier.Token | Out-Null
    }
}
