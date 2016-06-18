
properties {


    $projectRoot = $ENV:BHProjectPath
    if(-not $projectRoot) {
        $projectRoot = $PSScriptRoot
    }

    $sut = "$projectRoot\Watchmen"
    $tests = "$projectRoot\Tests"

    $psVersion = $PSVersionTable.PSVersion.Major
}

task default -depends Init, Analyze

task Init {
    "`nSTATUS: Testing with PowerShell $psVersion"
    "Build System Details:"
    Get-Item ENV:BH*
    
    $modules = 'Pester', 'PSDeploy', 'PSScriptAnalyzer', 'platyPS'
    Install-Module $modules -Confirm:$false
    Import-Module $modules -Verbose:$false -Force
}

task Test -Depends Init, Analyze, Pester

task Analyze -Depends Init {
    $saResults = Invoke-ScriptAnalyzer -Path $sut -Severity Error -Recurse -Verbose:$false
    if ($saResults) {
        $saResults | Format-Table
        Write-Error -Message 'One or more Script Analyzer errors/warnings where found. Build cannot continue!'
    }
}

task Pester -Depends Init {    
    $testResults = Invoke-Pester -Path $tests -PassThru
    if ($testResults.FailedCount -gt 0) {
        $testResults | Format-List
        Write-Error -Message 'One or more Pester tests failed. Build cannot continue!'
    }
}

task UpdateHelpMarkdown -Depends Init {
    Update-MarkdownHelp -Path "$projectRoot\ModuleHelp\*" -Encoding ([System.Text.Encoding]::Unicode)
}

task GenerateHelp -Depends Init {
    New-ExternalHelp -OutputPath "$sut\en-US" -Path "$projectRoot\ModuleHelp\*" -Force -Encoding ([System.Text.Encoding]::Unicode)
}

task Deploy -depends Test, GenerateHelp {
    # Gate deployment
    if(
        $ENV:BHBuildSystem -ne 'Unknown' -and
        $ENV:BHBranchName -eq "master" -and
        $ENV:BHCommitMessage -match '!deploy'
    ) {
        $params = @{
            Path = "$projectRoot\module.psdeploy.ps1"
            Force = $true
            Recurse = $false
        }

        Invoke-PSDeploy @Params
    } else {
        "Skipping deployment: To deploy, ensure that...`n" +
        "`t* You are in a known build system (Current: $ENV:BHBuildSystem)`n" +
        "`t* You are committing to the master branch (Current: $ENV:BHBranchName) `n" +
        "`t* Your commit message includes !deploy (Current: $ENV:BHCommitMessage)"
    }
}
