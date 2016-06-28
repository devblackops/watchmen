function Invoke-NotifierFilesystem {
    [cmdletbinding()]
    param(
        [parameter(Mandatory, ValueFromPipeline)]
        [ValidateScript({ $_.PSObject.TypeNames[0] -eq 'Watchmen.Notifier.FileSystem' })]
        [pscustomobject]$Notifier,

        [parameter(Mandatory)]
        [ValidateScript({ $_.PSObject.TypeNames[0] -eq 'OperationValidationResult' })]
        [pscustomobject]$Results
    )

    $o = ($Notifier | Format-Table -Property * -AutoSize | Out-String)
    Write-Debug -Message "File system notifier called with options:`n$o" 

    $time = "[$((Get-Date).ToUniversalTime().ToString('u'))]"
    $sev = 'ERROR'
    $msg = "$($Results.RawResult.Describe) -> $($Results.RawResult.Context) -> $($Results.RawResult.Name) -> $($Results.RawResult.Result.ToUpper())"
    $logEntry = "$time - $sev - $msg"

    foreach ($path in $Notifier.Path) {
        if (-not (Test-Path -LiteralPath $path)) {
            New-Item -ItemType File -Path $path -Force -ErrorAction Stop | Out-Null
        }
        $logEntry | Out-File -FilePath $path -Append -Encoding utf8
    }
}
