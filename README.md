# Watchmen

Infrastructure test runner using Pester


#### mytests.ps1
```powershell
ovfsetup {
    notifies @(
        email 'brandon@devblackops.io'
        filesystem '\\fileserver01\monitoringshare\'
        syslog 'mysyslogserver.mydomain.tld'
        eventlog
    )
}

ovftest 'MyOVFModule' {
    version 1.0.0             # Execute tests from a specific version of the module. Default is latest 
    type 'Simple'             # Valid values 'simple', 'comprehensive', 'all'. Default is 'all'
    test 'Storage.Capacity'   # Name of test to execute. Default is '*'
    keep 10                   # Keep (x) copies of previous runs. Send to Rorschach on test failure for context.
    fromSource 'PSGallery'
    parameters {              # Parameters that are passed into the Pester script like the example above.
        FreeSystemDriveThreshold = 40000
    }
    notifies @(
        email @('bgates@microsoft.com', 'emusk@teslamotors.com')
    )    
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