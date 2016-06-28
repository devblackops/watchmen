#requires -modules Posh-SYSLOG

function Invoke-NotifierSyslog {
    [cmdletbinding()]
    param(
        [parameter(Mandatory, ValueFromPipeline)]
        [ValidateScript({ $_.PSObject.TypeNames[0] -eq 'Watchmen.Notifier.Syslog' })]
        [pscustomobject]$Notifier,

        [parameter(Mandatory)]
        [ValidateScript({ $_.PSObject.TypeNames[0] -eq 'OperationValidationResult' })]
        [pscustomobject]$Results
    )

    if ($Notifier.Enabled) {

        Import-Module -Name Posh-SYSLOG -Verbose:$false -ErrorAction Stop

        $o = ($Notifier | Format-Table -Property * -AutoSize | Out-String)
        Write-Debug -Message "Syslog notifier called with options:`n$o"
    
        $msg = "$($Results.RawResult.Describe) -> $($Results.RawResult.Context) -> $($Results.RawResult.Name) -> $($Results.RawResult.Result.ToUpper())"

        foreach ($endpoint in $Notifier.Endpoint) {
            Send-SyslogMessage -Server $endpoint -Message $msg -Severity 'Critical' -Facility 'logalert'
        }
        
    }
}