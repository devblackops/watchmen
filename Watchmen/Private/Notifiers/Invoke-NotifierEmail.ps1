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
        Write-Debug -Message "Email notifier called with options:`n$o"


        # If a custom subject line was specified, replace any variables
        if (-not [string]::IsNullOrEmpty($Notifier.Subject)) {
            $Subject = ConvertFrom-PlaceholderString -InputObject $Notifier.Subject -Results $Results

        } else {
            $subject = "($env:COMPUTERNAME) - $($results.Result.ToUpper()) - $($results.RawResult.Name)"
        }

        # If a custom message was specified, replace any variables
        if (-not [string]::IsNullOrEmpty($Notifier.Message)) {
            $msg = ConvertFrom-PlaceholderString -InputObject $Notifier.Message -Results $Results
        } else {
            $msg = @"
Watchmen reported a failure in OVF test:

Module: $($results.Module)
File: $($results.FileName)
Describe: $($results.RawResult.Describe)
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
            SmtpServer = $Notifier.SmtpServer
            Subject = $subject
            Body = $msg
            UseSSL = $Notifier.UseSSL
            Port = $Notifier.Port
        }
        if ($Notifier.Credential) {
            $params.Credential = $Notifier.Credential
        }

        Send-MailMessage @params
    }
}
