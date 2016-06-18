function Invoke-WatchmenNotifier {
    [cmdletbinding()]
    param(
        $WatchmenTest,
        $TestResults
    )

    # Execute any 'Notifiers' in the Watchmen test

    if ($WatchmenTest.Notifiers.Count -ne 0) {
        foreach ($notifier in $WatchmenTest.Notifiers) {
            Write-Verbose -Message "Invoking notifier [$($notifier.type)]"
            switch ($notifier.type) {
                'Email' {
                    $notifier | Invoke-NotifierEmail -Results $TestResults
                }
                'EventLog' {
                    Invoke-NotifierEventLog -Notifier $notifier -Results $TestResults
                }
                'FileSystem' {
                    Invoke-NotifierFilesystem -Notifier $notifier -Results $TestResults
                }
                'Slack' {
                    Invoke-NotifierSlack -Notifier $notifier -Results $TestResults
                }
                'Syslog' {
                    Invoke-NotifierSyslog -Notifier $notifier -Results $TestResults
                }
                default {
                    Write-Error -Message "Unknown notifier [$($notifier.type)]"
                }
            }
        }
    }
}
