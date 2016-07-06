function Invoke-NotifierPowerShell {
    [cmdletbinding()]
    param(
        [parameter(Mandatory, ValueFromPipeline)]
        [ValidateScript({ $_.PSObject.TypeNames[0] -eq 'Watchmen.Notifier.PowerShell' })]
        [pscustomobject]$Notifier,

        [parameter(Mandatory)]
        [ValidateScript({ $_.PSObject.TypeNames[0] -eq 'OperationValidationResult' })]
        [pscustomobject]$Results
    )

    $o = ($Notifier | Format-Table -Property * -AutoSize | Out-String)
    Write-Debug -Message "PowerShell notifier called with options:`n$o"

    if ($null -ne $Notifier.ScriptBlock) {
        . $Notifier.ScriptBlock $results
    } elseIf ($null -ne $Notifier.ScriptPath) {
        . $Notifier.ScriptPath $Results
    }
}
