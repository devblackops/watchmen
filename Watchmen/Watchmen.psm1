$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
Foreach($import in @($Public + $Private)) {
    . $import.fullname
}

Export-ModuleMember -Function $Public.Basename
