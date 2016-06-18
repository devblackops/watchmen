[cmdletbinding()]
param(
    [string[]]$Task = 'default'
)

Get-PackageProvider -Name Nuget -ForceBootstrap | Out-Null

$reqModules = @('BuildHelpers', 'psake')
Install-Module $reqmodules -Confirm:$false
Import-Module $reqModules -Verbose:$false

Set-BuildEnvironment

Invoke-psake -buildFile "$PSScriptRoot\psake.ps1" -taskList $Task -nologo -Verbose:$VerbosePreference