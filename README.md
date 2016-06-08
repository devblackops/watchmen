# Watchmen

Infrastructure test runner using Pester


#### mytests.ps1
```powershell
ovftest 'MyOVFModule' {
    version 1.0.0             # Execute tests from a specific version of the module. Default is latest 
    type 'Simple'             # Valid values 'simple', 'comprehensive', 'all'. Default is 'all'
    test 'Storage.Capacity'   # Name of test to execute. Default is '*'
    fromSource 'PSGallery'
    parameters {              # Parameters that are passed into the Pester script like the example above.
        FreeSystemDriveThreshold = 40000
    }
}
```

Getting watchmen tests
```powershell
$tests = Get-WatchmenTest -Path .\Tests\myovf1.ps1
```

Executing watchmen tests
```powershell
$tests | Invoke-WatchmenTest -Verbose
```