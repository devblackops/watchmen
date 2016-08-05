
InModuleScope Watchmen {

    describe 'Syslog' {

        Mock -CommandName Assert-InWatchmen -MockWith {}

        it 'Returns a [Watchmen.Notifier.Syslog] object' {
            $o = Syslog 'syslog.mydomain.tld'
            $o.PSObject.TypeNames -contains 'Watchmen.Notifier.Syslog' | should be $true
        }

        it 'Should require the -Endpoints parameter' {
            $func = Get-Command -Name Syslog
            $func.Parameters.Endpoints.Attributes.Mandatory | should be $true    
        }
    }
}
