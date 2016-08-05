
InModuleScope Watchmen {

    describe 'EventLog' {

        Mock -CommandName Assert-InWatchmen -MockWith {}

        it 'Returns a [Watchmen.Notifier.EventLog] object' {
                      
            $e = @{                
                EventType = 'Error'
                EventId = 1         
            }
            $o = EventLog -Options $e
            $o.PSObject.TypeNames -contains 'Watchmen.Notifier.EventLog' | should be $true
        }

        it 'Should require the -Options parameter' {
            $func = Get-Command -Name EventLog
            $func.Parameters.Options.Attributes.Mandatory | should be $true    
        }
    }
}
