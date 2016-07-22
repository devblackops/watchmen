properties {
    $projectRoot = $ENV:BHProjectPath
    if(-not $projectRoot) {
        $projectRoot = $PSScriptRoot
    }

    $sut = "$projectRoot\Watchmen"
    $tests = "$projectRoot\Tests"

    $psVersion = $PSVersionTable.PSVersion.Major
}

task default -depends Test

task Init {
    "`nSTATUS: Testing with PowerShell $psVersion"
    "Build System Details:"
    Get-Item ENV:BH*

    $modules = 'Pester', 'PSDeploy', 'PSScriptAnalyzer', 'platyPS', 'PSSlack', 'Posh-SYSLOG'
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
   
    if(-not $ENV:BHProjectPath) {
        Set-BuildEnvironment -Path $PSScriptRoot\..
    }
    Remove-Module $ENV:BHProjectName -ErrorAction SilentlyContinue
    Import-Module (Join-Path $ENV:BHProjectPath $ENV:BHProjectName) -Force

    $testResults = Invoke-Pester -Path $tests -PassThru
    if ($testResults.FailedCount -gt 0) {
        $testResults | Format-List
        Write-Error -Message 'One or more Pester tests failed. Build cannot continue!'
    }
}

task UpdateHelpMarkdown -Depends Init {
    Import-Module -Name $sut -Force
    Update-MarkdownHelp -Path "$projectRoot\docs\functions" -Encoding ([System.Text.Encoding]::UTF8)
}

task GenerateHelp -Depends Init {
    New-ExternalHelp -OutputPath "$sut\en-US" -Path "$projectRoot\docs\functions" -Force -Encoding ([System.Text.Encoding]::UTF8)
}

task ExportFunctions {
    $files = Get-ChildItem -Path $sut\Public | Select -ExpandProperty Name
    $functions = @()
    $files | % {
        $functions += $_.Split('.')[0]
    }
    Update-ModuleManifest -Path $sut\Watchmen.psd1 -FunctionsToExport $functions
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
