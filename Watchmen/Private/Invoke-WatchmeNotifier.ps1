function Invoke-WatchmenNotifier {
    [cmdletbinding()]
    param(
        [parameter(Mandatory, ValueFromPipeline)]
        [pscustomobject[]]$TestResults,

        [pscustomobject]$WatchmenTest
    )

    begin {
        # If this test doesn't have any notifiers, don't bother
        # going through the pipeline even if the test results
        # have a failure
        if ($WatchmenTest.Notifiers.Count -ne 0) { return }
    }

    process {
        foreach ($testResult in $TestResults) {
            $results = @()

            # TODO
            # Act on any errors from the notifiers

            foreach ($key in $WatchmenTest.Notifiers.Keys) {
                $notifierType = $WatchmenTest.Notifiers.$key
                if ($notifierType.Count -gt 0) {
                    foreach ($notifier in $notifierType) {
                        if ($notifier.Enabled) {
                            
                            # Only execute the notifier if one of the following conditions are met
                            if ( ($notifier.NotifierCondition -eq 'Always') -or
                                 ($notifier.NotifierCondition -eq 'OnSuccess' -and $testResult.Result -eq 'Passed') -or
                                 ($notifier.NotifierCondition -eq 'OnFailure' -and $testResult.Result -eq 'Failed')) {

                                Write-Verbose -Message "  Calling notifier [$($notifier.type)]"                               

                                switch ($notifier.type) {
                                    'Email' {
                                        $results += $notifier | Invoke-NotifierEmail -Results $testResult
                                    }
                                    'EventLog' {
                                        $results += $notifier | Invoke-NotifierEventLog -Results $testResult
                                    }
                                    'InfluxDB' {
                                        $results += $notifier | Invoke-NotifierInfluxDB -Results $testResult
                                    }
                                    'LogFile' {
                                        $results += $notifier | Invoke-NotifierLogFile -Results $testResult
                                    }
                                    'PowerShell' {
                                        $results += $notifier | Invoke-NotifierPowerShell -Results $testResult
                                    }
                                    'Slack' {
                                        $results += $notifier | Invoke-NotifierSlack -Results $testResult
                                    }
                                    'Syslog' {
                                        $results += $notifier | Invoke-NotifierSyslog -Results $testResult
                                    }
                                    default {
                                        Write-Error -Message "Unknown notifier [$($notifier.type)]"
                                    }
                                }
                            }
                        } else {
                            Write-Verbose -Message "Skipping notifier [$($notifier.type)]. Disabled for this test."
                        }
                    }
                }
            }
            $results
        }
    }

    end { }
}
