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
        Write-Verbose -Message "Slack notifier called with options:`n$o" 
        
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
            @{title = 'Computer'; value = $env:COMPUTERNAME }
            @{title = 'Test'; value = $results.RawResult.Name }
            @{title = 'Module'; value = $results.Module }
            @{title = 'File'; value = $results.FileName }
            @{title = 'Descibe'; value = $results.RawResult.Describe }
            @{title = 'Context'; value = $results.RawResult.Context }    
            @{title = 'Result'; value = $results.Result }
            @{title = 'Message'; value = $results.RawResult.FailureMessage }
            @{title = 'Duration'; value = $results.RawResult.Time.ToString() }
        )

        $params = @{
            Color = [System.Drawing.Color]::Red 
            Title = "Test details:"
            TitleLink = $Notifier.TitleLink
            Fields = $fields
            PreText = "$($Notifer.IconEmoji) $($env:COMPUTERNAME) - $($results.Result.ToUpper()) - $($results.RawResult.Name)"
            AuthorName = $Notifier.AuthorName
            Fallback = $text
        }
        $att = New-SlackMessageAttachment @params
        if ($Notifier.IconEmoji -ne [string]::Empty) {        
            $msg = $att | New-SlackMessage -Channel $Notifer.Channel -IconEmoji $Notifier.IconEmoji
        } else {
            $msg = $att | New-SlackMessage -Channel $Notifer.Channel -IconUrl $Notifier.IconUrl
        }    
        $msg | Send-SlackMessage -Uri $Notifier.Token
    }
}
