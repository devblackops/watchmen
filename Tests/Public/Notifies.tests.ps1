
InModuleScope Watchmen {

    describe 'Notifies' {

        Mock -CommandName Assert-InWatchmen -MockWith {}

        # Define the notifiers
        WatchmenOptions {
            notifies {
                email @{
                    FromAddress = 'watchmen@mydomain.tld'
                    Subject = 'Something bad happended'
                    Message = 'Danger! Danger!'
                    SmtpServer = 'smtp.mydomain.tld'
                    Port = 25
                    UseSSL = $false
                    To = 'admin@mydomain.tld'
                }
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
                    Token = 'https://hooks.slack.com/services/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'
                    Channel = '#Watchmen_Alerts'
                    TitleLink = 'www.google.com'
                    AuthorName = $env:COMPUTERNAME
                    PreText = 'Everything is on :fire:'
                    IconEmoji = ':fire:'
                }
            }
        }

        it 'Email notifier defined' {
            $global:Watchmen.Options.Notifiers.email | should not benullorempty
        }

        it 'Eventlog notifier defined' {
            $global:Watchmen.Options.Notifiers.eventlog | should not benullorempty
        }

        it 'LogFile notifier defined' {
            $global:Watchmen.Options.Notifiers.logfile | should not benullorempty
        }

        it 'PowerShell notifier defined' {
            $global:Watchmen.Options.Notifiers.powershell | should not benullorempty
        }

        it 'Slack notifier defined' {
            $global:Watchmen.Options.Notifiers.slack | should not benullorempty
        }

        it 'Syslog notifier defined' {
            $global:Watchmen.Options.Notifiers.syslog | should not benullorempty
        }
    }
}
