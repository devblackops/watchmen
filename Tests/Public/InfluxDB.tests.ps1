
InModuleScope Watchmen {

    describe 'InfluxDB' {

        Mock -CommandName Assert-InWatchmen -MockWith {}

        it 'Returns a [Watchmen.Notifier.InfluxDB] object' {                    
            $i = @{
                Url = 'http://localhost'
                Port = 8086
                Database = $Options.Database
                MeasurementName = 'watchmen_test'
                Tags = @{}
                RetentionPolicy = [string]::Empty
                WriteConsistency = [string]::Empty
                Timeout = 5
                Credential = $null
                UserAgent = 'Watchmen'
                Enabled = $true
                SkipSSLVerification = $false
                NotifierCondition = $When
            }
            $o = InfluxDB -Options $i
            $o.PSObject.TypeNames -contains 'Watchmen.Notifier.InfluxDB' | should be $true
        }

        it 'Should require the -Options parameter' {
            $func = Get-Command -Name InfluxDB
            $func.Parameters.Options.Attributes.Mandatory | should be $true    
        }
    }
}
