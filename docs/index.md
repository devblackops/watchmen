# Watchmen

Infrastructure test runner and notification system using
[Operation Validation Framework (OVF)](https://github.com/PowerShell/Operation-Validation-Framework) PowerShell modules and Pester.

## Overview
Watchmen is a PowerShell module to make executing Pester tests contained in OVF modules easier using a simple PowerShell-based Domain Specific
Language (DSL). It also provides the ability to execute a number of actions (notifiers) upon failing (or successful) infrastructure tests. Watchmen
can also dynamically install OVF modules from public or private PowerShell repositories like the [PowerShell Gallery](https://www.powershellgallery.com/)
should the module not be found on the system.

## What is OVF?
The [Operation Validation Framework](https://github.com/PowerShell/Operation-Validation-Framework) is a PowerShell module used to execute
[Pester](https://github.com/pester/Pester) tests that validate the operation of a **system** rather than test the behavior of code. This could mean
running tests that validate certain Windows services are running and IIS is responding on port 443.

An OVF module is a PowerShell module that includes Pester tests in a certain folder structure:

- ModuleBase\
  - ModuleName.psd1
  - Diagnostics\
    - Simple\
      - simple.tests.ps1 *simple tests (e.g., service checks, endpoint checks)*
    - Comprehensive\
      - comprehensive.tests.ps1 *comprehensive scenario tests*

#### Example infrastructure tests
* Service 'W3SVC' is running
* Localhost responds on port 443 with HTTP code 200.
* All volumes have a minimum of 5GB free space.

## Why OVF?
Pester tests packaged into a PowerShell module gain the immediate benefit of being versionable just like any other PowerShell module. They also are
easily publishable to public or private NuGet-based repositories like the [PowerShell Gallery](https://www.powershellgallery.com/). This facilitates
high quality test modules that validate common infrastructure to be shared and improved upon by the broader community.

## Example Watchmen File
The example Watchmen file below will execute Pester tests contained inside the **MyAppOVF** module installed on the location machine. Upon any failing
(or optionally successful) tests, Watchmen will then execute a number of notifiers such as sending an email, writing to the eventlog, appending to a
log file, executing an arbitrary PowerShell script block or script, sending a message to a Slack channel, and send a message to a syslog server.

#### myapp.watchmen.ps1
```powershell
# Global notifiers that are executed upon any failing test
WatchmenOptions {
    notifies {
        When 'OnFailure'
        email @{
            fromAddress = 'watchmen@mydomain.tld'
            smtpServer = 'smtp.mydomain.tld'
            port = 25
            subject = 'Watchmen alert - #{computername} - [#{test}] failed!'
            to = 'admin@mydomain.tld'
        }
        eventlog @{
            eventid = 1
            eventtype = 'error'
        }
        eventlog @{
            eventid = 100
            eventtype = 'information'
        } -when 'onsuccess'
        logfile '\\fileserver01.mydomain.tld\monitoringshare\#{computername}.log'
        powershell {
            Write-Host "Something bad happended! $args[0]"
        }
        powershell '\notifier.ps1'
        slack @{
            Token = '<webhookurl>'
            Channel = '#Watchmen'
            AuthorName = $env:COMPUTERNAME
            PreText = 'Everything is on :fire:'
            IconEmoji = ':fire:'
        }
        syslog 'syslog.mydomain.tld' -when 'always'
    }
}

# Execute the 'Storage.Capacity' tests in version 1.0.0 of the 'MyAppOVF' module
WatchmenTest 'MyAppOVF' {
    version 1.0.0                   # Execute tests from a specific version of the module. Default is latest 
    testType 'Simple'               # Valid values 'simple', 'comprehensive', 'all'. Default is 'all'
    test 'Storage.Capacity'         # Name of test to execute. Default is '*'
    fromSource 'PSGallery'          # Name of PowerShell repository to install module from if not found on system.
    parameters {                    # Parameters that are passed into the Pester script to change the behaviour of the test.
        FreeSystemDriveThreshold = 40000
    }
    notifies {                      # Notifiers to execute for this test in addition to ones defined in 'WatchmenOptions'
        logfile '\\fileserver01.mydomain.tld\monitoringshare\#{computername}.log' -when 'always'
    }
}

# Execute all tests in the SystemOVF module and install module from the 'PSPrivateGallery' repository if not installed on the system.
# Global notifiers will be executed upon any failing tests.
WatchmenTest 'SystemOVF' {
    fromSource 'PSPrivateGallery'
}
```

## Using Watchmen
A Watchmen file is a PowerShell script that can be read by calling **Get-WatchmenTest**. The object(s) returned represent the OVF tests to execute
and the associated notifiers to call upon any failing tests. Running **Invoke-WatchmenTest** will execute the tests and call any notifiers as
appropriate.

Getting watchmen tests
```powershell
$tests = Get-WatchmenTest -Path '.\myapp.watchmen.ps1'
```

Executing watchmen tests
```powershell
$tests | Invoke-WatchmenTest -Verbose -IncludePesterOutput
```
