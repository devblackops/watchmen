
properties {
    $sut = '.\Watchmen'
    $tests = '.\Tests'
}

task default -depends Prereqs, Analyze, Test

task Prereqs {
    $modules = 'Pester', 'PSDeploy', 'PSScriptAnalyzer'
    Install-Module $modules -Confirm:$false
    Import-Module $modules -verbose:$false
}

task Analyze {
    $saResults = Invoke-ScriptAnalyzer -Path $sut -Severity Error -Recurse -Verbose:$false
    if ($saResults) {
        $saResults | Format-Table
        Write-Error -Message 'One or more Script Analyzer errors/warnings where found. Build cannot continue!'
    }
}

task test {
    $testResults = Invoke-Pester -Path $tests -PassThru
    if ($testResults.FailedCount -gt 0) {
        $testResults | Format-List
        Write-Error -Message 'One or more Pester tests failed. Build cannot continue!'
    }
}

task deploy

