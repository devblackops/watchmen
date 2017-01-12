function Invoke-NotifierLogFile {
    [cmdletbinding()]
    param(
        [parameter(Mandatory, ValueFromPipeline)]
        [ValidateScript({ $_.PSObject.TypeNames[0] -eq 'Watchmen.Notifier.LogFile' })]
        [pscustomobject]$Notifier,

        [parameter(Mandatory)]
        [ValidateScript({ $_.PSObject.TypeNames[0] -eq 'OperationValidationResult' })]
        [pscustomobject]$Results
    )

    $o = ($Notifier | Format-Table -Property * -AutoSize | Out-String)
    Write-Debug -Message "Log file notifier called with options:`n$o"

    $time = "[$((Get-Date).ToUniversalTime().ToString('u'))]"
    $sev = 'ERROR'
    $msg = "$($Results.RawResult.Describe) -> $($Results.RawResult.Context) -> $($Results.RawResult.Name) -> $($Results.RawResult.Result.ToUpper())"
    $logEntry = "$time - $sev - $msg"

    foreach ($path in $Notifier.Path) {
        $ResolvedPath = ConvertFrom-PlaceholderString -InputObject $Path -Results $Results

        if (-not (Test-Path -LiteralPath $ResolvedPath)) {
            New-Item -ItemType File -Path $ResolvedPath -Force -ErrorAction Stop | Out-Null
        }
        $logEntry | Out-File -FilePath $ResolvedPath  -Append -Encoding utf8
    }
}
