[cmdletbinding()]
param(
    [string[]]$Task = 'default'
)

Get-PackageProvider -Name Nuget -ForceBootstrap | Out-Null
if (!(Get-Module -Name BuildHelpers -ListAvailable)) { Install-Module -Name BuildHelpers }
if (!(Get-Module -Name psake -ListAvailable)) { Install-Module -Name psake }

Set-BuildEnvironment

Invoke-psake -buildFile "$PSScriptRoot\psake.ps1" -taskList $Task -nologo -Verbose:$VerbosePreference