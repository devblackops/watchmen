function Get-OperationValidation {
    <#
    .SYNOPSIS
    Retrieve the operational tests from modules

    .DESCRIPTION
    Modules which include a Diagnostics directory are inspected for
    Pester tests in either the "Simple" or "Comprehensive" directories.
    If files are found in those directories, they will be inspected to determine
    whether they are Pester tests. If Pester tests are found, the
    test names in those files will be returned.

    The module structure required is as follows:

    ModuleBase\
        Diagnostics\
            Simple         # simple tests are held in this location
                            (e.g., ping, serviceendpoint checks)
            Comprehensive  # comprehensive scenario tests should be placed here

    .PARAMETER ModuleName
    By default this is * which will retrieve all modules in $env:psmodulepath
    Additional module directories may be added. If you wish to check both
    $env:psmodulepath and your own specific locations, use
    *,<yourmodulepath>

    .PARAMETER Type
    The type of tests to retrieve, this may be either "Simple", "Comprehensive"
    or Both ("Simple,Comprehensive"). "Simple,Comprehensive" is the default.

    .EXAMPLE
    PS> Get-OperationValidation -ModuleName C:\temp\modules\AddNumbers

        Type:         Simple
        File:     addnum.tests.ps1
        FilePath: C:\temp\modules\AddNumbers\Diagnostics\Simple\addnum.tests.ps1
        Name:
            Add-Em
            Subtract em
            Add-Numbers
        Type:         Comprehensive
        File:     Comp.Adding.Tests.ps1
        FilePath: C:\temp\modules\AddNumbers\Diagnostics\Comprehensive\Comp.Adding.Tests.ps1
        Name:
            Comprehensive Adding Tests
            Comprehensive Subtracting Tests
            Comprehensive Examples

    .LINK
    Invoke-OperationValidation
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position=0)]
        [string[]]$ModuleName = "*",

        [ValidateSet("Simple","Comprehensive")]
        [string[]]$TestType =  @("Simple","Comprehensive"),

        [version]$Version
    )

    BEGIN {



        #$testTypes = $type.Tostring().Replace(" ","").split(",")
        function Get-TestName ( $ast ) {
            for($i = 1; $i -lt $ast.Parent.CommandElements.Count; $i++) {
                if ( $ast.Parent.CommandElements[$i] -is "System.Management.Automation.Language.CommandParameterAst") { $i++; continue }
                if ( $ast.Parent.CommandElements[$i] -is "System.Management.Automation.Language.ScriptBlockExpressionAst" ) { continue }
                if ( $ast.Parent.CommandElements[$i] -is "System.Management.Automation.Language.StringConstantExpressionAst" ) { return $ast.Parent.CommandElements[$i].Value }
            }
            throw "Could not determine test name"
        }

        function Get-TestFromAst ( $ast ) {
            $eb = $ast.EndBlock
            foreach($statement in $eb.Statements) {
                if ( $statement -isnot "System.Management.Automation.Language.PipelineAst" ) {
                    continue
                }
                $CommandAst = $statement.PipelineElements[0].CommandElements[0]

                if (  $CommandAst.Value -eq "Describe" ) {
                    Get-TestName $CommandAst
                }
            }
        }

        function Get-TestCaseNamesFromAst ( $ast ) {
            $eb = $ast.EndBlock
            foreach($statement in $eb.Statements) {
                if ( $statement -isnot "System.Management.Automation.Language.PipelineAst" ) {
                    continue
                }
                $CommandAst = $statement.PipelineElements[0].CommandElements[0]

                if (  $CommandAst.Value -eq "It" ) {
                    Get-TestName $CommandAst
                }
            }
        }

        function Get-ModuleList  {
            param (
                [string[]]$Name,
                [version]$Version
            )

            foreach($p in $env:psmodulepath.split(";")) {
                if ( test-path -path $p ) {
                    foreach($modDir in get-childitem -path $p -directory) {
                        foreach ($n in $name ) {
                            if ( $modDir.Name -like $n ) {
                                # now determine if there's a diagnostics directory, or a version
                                if ( test-path -path ($modDir.FullName + "\Diagnostics")) {

                                    # Did we specify a specific version to find?
                                    if ($PSBoundParameters.ContainsKey('Version')) {
                                        $manifestFile = Get-ChildItem -Path $modDir.FullName -Filter '*.psd1' | Select-Object -First 1
                                        $manifest = Test-ModuleManifest -Path $manifestFile.FullName
                                        if ($manifest.Version -eq $Version) {
                                            $modDir.FullName
                                            break
                                        }
                                    } else {
                                    $modDir.FullName
                                    break
                                    }
                                }

                                # Get latest version of no specific version specified
                                if ($PSBoundParameters.ContainsKey('Version')) {
                                    $versionDirectories = Get-Childitem -path $modDir.FullName -dir |
                                        where-object { $_.name -as [version] -and $_.Name -eq $Version }
                                } else {
                                    $versionDirectories = Get-Childitem -path $modDir.FullName -dir |
                                        where-object { $_.name -as [version] }
                                }

                                $potentialDiagnostics = $versionDirectories | where-object {
                                    test-path ($_.fullname + "\Diagnostics")
                                    }
                                # now select the most recent module path which has diagnostics
                                $DiagnosticDir = $potentialDiagnostics |
                                    sort-object {$_.name -as [version]} |
                                    Select-Object -Last 1
                                if ( $DiagnosticDir ) {
                                    $DiagnosticDir.FullName
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    PROCESS {
        Write-Progress -Activity "Inspecting Modules" -Status " "
        if ($PSBoundParameters.ContainsKey('Version')) {
            $moduleCollection = Get-ModuleList -Name $ModuleName -Version $Version
        } else {
            $moduleCollection = Get-ModuleList -Name $ModuleName
        }
        $count = 1;
        $moduleCount = @($moduleCollection).Count
        foreach($module in $moduleCollection) {
            Write-Progress -Activity ("Searching for Diagnostics in " + $module) -PercentComplete ($count++/$moduleCount*100) -status " "
            $diagnosticsDir=$module + "\Diagnostics"
            if ( test-path -path $diagnosticsDir ) {
                foreach($dir in $TestType) {
                    $testDir = "$diagnosticsDir\$dir"
                    Write-Verbose -Message "TEST DIR: $testDir"
                    if ( ! (test-path -path $testDir) )  {
                        continue
                    }
                    foreach($file in get-childitem -path $testDir -filter *.tests.ps1) {
                        Write-Verbose -Message "TEST SCRIPT: $($file.fullname)"

                        $script = Get-Command -Name $file.fullname
                        $parameters = $script.Parameters
                        if ($parameters.Keys.Count -gt 0) {
                            Write-Debug -Message 'Test script has overrideable parameters'
                            Write-Debug -Message "`n$($parameters.Keys | Out-String)"
                        }

                        $testName = Get-TestFromScript -scriptPath $file.FullName
                        New-OperationValidationInfo -FilePath $file.Fullname -File $file.Name -Type $dir -Name $testName -ModuleName $Module -Parameters $parameters
                    }
                }
            }
        }
    }
}
