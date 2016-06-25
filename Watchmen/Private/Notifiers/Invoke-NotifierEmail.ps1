function Invoke-NotifierEmail {
    [cmdletbinding()]
    param(
        [parameter(Mandatory, ValueFromPipeline)]
        [ValidateScript({ $_.PSObject.TypeNames[0] -eq 'Watchmen.Notifier.Email' })]
        [pscustomobject]$Notifier,

        [parameter(Mandatory)]
        [ValidateScript({ $_.PSObject.TypeNames[0] -eq 'OperationValidationResult' })]
        [pscustomobject]$Results
    )

    if ($Notifier.Enabled) {
        $o = ($Notifier | Format-Table -Property *  -AutoSize| Out-String)
        Write-Verbose -Message "Email notifier called with options:`n$o"

        # If a custom subject line was specified, replace any variables
        if (($Notifier.Subject -ne [string]::Empty) -and ($null -ne $Notifier.Subject)) {
            $subject = $Notifier.Subject
            $subject = $subject.Replace('#{module}', $results.module)
            $subject = $subject.Replace('#{file}', $results.FileName)
            $subject = $subject.Replace('#{descibe}', $results.RawResult.Describe)
            $subject = $subject.Replace('#{context}', $results.RawResult.Context)
            $subject = $subject.Replace('#{test}', $results.RawResult.Name)
            $subject = $subject.Replace('#{result}', $results.Result)
            $subject = $subject.Replace('#{failureMessage}', $results.RawResult.FailureMessage)
            $subject = $subject.Replace('#{duration}', $results.RawResult.Time.ToString())
        } else {
            $subject = "($env:COMPUTERNAME) - $($results.Result.ToUpper()) - $($results.RawResult.Name)"
        }

        # If a custom message was specified, replace any variables
        if (($Notifier.Message -ne [string]::Empty) -and ($null -ne $Notifier.Message)) {
            $msg = $Notifier.Message
            $msg = $msg.Replace('#{module}', $results.module)
            $msg = $msg.Replace('#{file}', $results.FileName)
            $msg = $msg.Replace('#{descibe}', $results.RawResult.Describe)
            $msg = $msg.Replace('#{context}', $results.RawResult.Context)
            $msg = $msg.Replace('#{test}', $results.RawResult.Name)
            $msg = $msg.Replace('#{result}', $results.Result)
            $msg = $msg.Replace('#{failureMessage}', $results.RawResult.FailureMessage)
            $msg = $msg.Replace('#{duration}', $results.RawResult.Time.ToString())
        } else {
            $msg = @"
Watchmen reported a failure in OVF test:

Module: $($results.Module)

File: $($results.FileName)

Descibe:  $($results.RawResult.Describe)

Context: $($results.RawResult.Context)

Test: $($results.RawResult.Name)

Result: $($results.Result)

Message: $($results.RawResult.FailureMessage)

Duration: $($results.RawResult.Time.ToString())
"@
        }

        $params = @{
            To =  $Notifier.To
            From = $Notifier.FromAddress
            SmtpHost = $Notifier.SmtpServer
            Subject = $subject
            Body = $msg
        }
        Send-MailMessage @params 
    }
}
