
properties {
    
}

task default -depends prereqs

task prereqs {
    if (!(Get-Module -Name Pester -ListAvailable)) { Install-Module -Name Pester }
    if (!(Get-Module -Name PSDeploy -ListAvailable)) { Install-Module -Name PSDeploy }
    if (!(Get-Module -Name PSScriptAnalyzer -ListAvailable)) { Install-Module -Name PSDeploy }
}

task test

task deploy

