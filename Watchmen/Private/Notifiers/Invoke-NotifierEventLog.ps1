function Invoke-NotifierEventLog {
    [cmdletbinding()]
    param(
        [parameter(Mandatory, ValueFromPipeline)]
        [ValidateScript({ $_.PSObject.TypeNames[0] -eq 'Watchmen.Notifier.EventLog' })]
        [pscustomobject]$Notifier,

        [parameter(Mandatory)]
        [ValidateScript({ $_.PSObject.TypeNames[0] -eq 'OperationValidationResult' })]
        [pscustomobject]$Results
    )

    $o = ($Notifier | Format-Table -Property *  -AutoSize| Out-String)
    Write-Debug -Message "Event log notifier called with options:`n$o"

    # TODO
    # Even though we're specifying the 'Application' log, Write-EventLog is writing these events to the 'System' log.class Name
    # Need to investigate if this is a bug with PowerShell v5.1 or is happening on other PS versions.

    # Register 'Watchmen' event source if needed and create log entry
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
    $params = @{
        LogName = 'Application'
        Source = 'Watchmen'
        EventId = $Notifier.EventId
        EntryType = $Notifier.EventType
        Message = $msg
    }
    New-EventLog -LogName $params.LogName -Source 'Watchmen' -ErrorAction Ignore
    Write-EventLog @params
}
