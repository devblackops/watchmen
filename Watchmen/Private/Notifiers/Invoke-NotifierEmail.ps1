function Invoke-NotifierEmail {
    param(
        [parameter(Mandatory, ValueFromPipeline)]
        [ValidateScript({ $_.PSObject.TypeNames[0] -eq 'Watchmen.Notifier.Email' })]
        [pscustomobject]$Notifier,

        [parameter(Mandatory)]
        [ValidateScript({ $_.PSObject.TypeNames[0] -eq 'OperationValidationResult' })]
        [pscustomobject]$Results

    )

    $o = ($Notifier | Format-Table -Property *  -AutoSize| Out-String)
    Write-Verbose -Message "Email notifier called with options:`n$o"
}