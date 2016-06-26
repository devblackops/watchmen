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

            foreach ($notifier in $WatchmenTest.Notifiers) {
                if ($notifier.Enabled) {
                    Write-Verbose -Message "Invoking notifier [$($notifier.type)]"
                    switch ($notifier.type) {
                        'Email' {
                            $results += $notifier | Invoke-NotifierEmail -Results $testResult
                        }
                        'EventLog' {
                            $results += $notifier | Invoke-NotifierEventLog -Results $testResult
                        }
                        'FileSystem' {
                            $results += $notifier | Invoke-NotifierFilesystem -Results $testResult
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
                } else {
                    Write-Verbose -Message "Skipping notifier [$($notifier.type)]. Disabled for this test."
                }
            }
            return $results
        }
    }

    end { }
}
