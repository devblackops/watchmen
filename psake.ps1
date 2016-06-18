
properties {
    
}

task default -depends prereqs

task prereqs {
    $modules = 'Pester', 'PSDeploy', 'PSScriptAnalyzer'
    Install-Module $modules
    Import-Module $modules -verbose:$false
}

task test

task deploy

