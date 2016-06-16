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
                    Invoke-NotifierEmail -Test $WatchmenTest -Results $TestResults
                }
                'EventLog' {
                    Invoke-NotifierEventLog -Test $WatchmenTest -Results $TestResults
                }
                'FileSystem' {
                    Invoke-NotifierFilesystem -Test $WatchmenTest -Results $TestResults
                }
                'Slack' {
                    Invoke-NotifierSlack -Test $WatchmenTest -Results $TestResults
                }
                'Syslog' {
                    Invoke-NotifierSyslog -Test $WatchmenTest -Results $TestResults
                }
                default {
                    Write-Error -Message "Unknown notifier [$($notifier.type)]"
                }
            }
        }
    }
}