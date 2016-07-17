function New-OperationValidationInfo {
    param (
        [Parameter(Mandatory=$true)][string]$File,
        [Parameter(Mandatory=$true)][string]$FilePath,
        [Parameter(Mandatory=$true)][string[]]$Name,
        [Parameter()][string[]]$TestCases,
        [Parameter(Mandatory=$true)][ValidateSet("None","Simple","Comprehensive")][string]$Type,
        [Parameter()][string]$modulename,
        [hashtable]$Parameters
    )

    $o = [pscustomobject]@{
        PSTypeName = 'OperationValidationInfo'
        File = $File
        FilePath = $FilePath
        Name = $Name
        TestCases = $testCases
        Type = $type
        ModuleName = $modulename
        ScriptParameters = $Parameters
    }
    #$o.psobject.Typenames.Insert(0,"OperationValidationInfo")
    $ToString = { return ("{0} ({1}): {2}" -f $this.testFile, $this.Type, ($this.TestCases -join ",")) }
    Add-Member -inputobject $o -membertype ScriptMethod -Name ToString -Value $toString -Force
    $o
}
