WatchmenOptions {
    rorschach @{
        endpoint = 'rorschach.local'
        credential = $null
    }
    notifies {
        email 'brandon@devblackops.io'        
    }
}

# This test should PASS
WatchmenTest 'MyOVFModule' {
    version 0.1.0
    testType 'simple'
    test 'storage.capacity'
    fromsource 'psgallery'
    parameters @{
        FreeSystemDriveThreshold = 1000
    }
    notifies {
        email 'bgates@microsoft.com'
        email @(
            'john@doe.com'
            'jan@doe.com'
        )
    }
}

# This test should FAIL
WatchmenTest 'MyOVFModule' {
    version 0.1.0
    testType 'simple'
    test 'storage.capacity'
    fromsource 'psgallery'
    parameters @{
        FreeSystemDriveThreshold = 50000
    }
    notifies {
        email 'someguy@somecompany.com'
    }
}

# WatchmenTest 'mymodule' {
#     version 1.6.0
#     testType 'comprehensive'
#     test 'myapp.tests'
#     fromsource 'psgallery'
#     parameters @{
#         abc = 123
#     }
# }

# WatchmenOptions {
#     notifies {
#         slack @{
#             channel = '#watchmen'
#             webhook = 'https://slack.com/234902348fsdflkasdfj'
#         }
#         slack @{
#             channel = '#alerts'
#             webhook = 'https://slack.com/asdfasdfasdf'
#         }
#         slack @(
#             @{channel = '#everyone'; webhook = 'www.google.com'}
#             @{channel = '#everyone2'; webhook = 'www.google.com'}
#         )
#     }
# }

# WatchmenTest 'mymodule' {
#     version 1.6.0
#     testType 'comprehensive'
#     test 'myapp.tests'
#     fromsource 'psgallery'
#     parameters @{
#         abc = 123
#     }
# }

# ovfsetup {    
#     filesystem '\\fileserver01\monitoringshare\', '\\nas01\alerts'
#     filesystem '\\fileasdf\myalerts'
#     syslog 'mysyslogserver.mydomain.tld'
#     syslog 'logs.mydomain.tld', '10.10.10.10'
#     eventlog @{
#         log = 'application'
#         eventid = '123'
#     }
#     eventlog @{
#         log = 'system'
#         eventid = '123'
#     }
#     eventlog @(
#         @{ log = 'myalerts'; eventid = '123' }
#         @{ log = 'myapp.monitoring'; eventid = '42' }
#     )
# }