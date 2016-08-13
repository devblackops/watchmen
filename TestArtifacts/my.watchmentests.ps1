
WatchmenOptions {
    notifies {
        eventlog @{
            eventid = '1'
            eventtype = 'error'
        }
        eventlog @{
            eventid = '10'
            eventtype = 'warning'
        }
        logfile 'c:\temp\watchmen.log'
        logfile @(
            'c:\temp\watchmen2.log',
            'c:\temp\watchmen3.log'
        )
        syslog 'localhost'
        syslog @(
            'endpoint1.mydomain.tld',
            'endpoint2.mydomain.tld'
        )
        powershell {
            Write-Host ("There was an error! $args[0]")
        }
        powershell {
            '.\notify.ps1'
        }
        slack @{
            Token = $env:WATCHMEN_SLACK_WEBHOOK
            Channel = '#Watchmen_Alerts'
            TitleLink = 'www.google.com'
            AuthorName = $env:COMPUTERNAME
            PreText = 'Everything is on :fire:'
            IconEmoji = ':fire:'
        }
    }
}

# This test should PASS
WatchmenTest 'OVF.Example1' {
    version 0.1.0
    test 'Storage Capacity'
    notifies {
        syslog @(
            '1.2.3.4', 'syslog.mydomain.tld'
        )
    }
}

# This test should FAIL and call (2) additional notifiers
WatchmenTest 'OVF.Example1' {
    version 0.1.0
    parameters @{
        FreeSystemDriveThreshold = 50000
    }        
    notifies {
        logfile 'c:\temp\watchmen2.log'
        powershell '.\notify.ps1'
    }
}

# Run tests with defaults for everything
WatchmenTest 'OVF.Example2' {
    testtype 'all'
}

# This test should FAIL because module is missing
# WatchmenTest 'MyOVFModule' {
#     fromsource 'PSGallery'
# }
