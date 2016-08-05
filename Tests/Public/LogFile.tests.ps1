
InModuleScope Watchmen {

    describe 'LogFile' {

        Mock -CommandName Assert-InWatchmen -MockWith {}

        it 'Returns a [Watchmen.Notifier.LogFile] object' {
            $o = LogFile 'c:\temp\watchmen.log'
            $o.PSObject.TypeNames -contains 'Watchmen.Notifier.LogFile' | should be $true
        }

        it 'Should require the -Path parameter' {
            $func = Get-Command -Name LogFile
            $func.Parameters.Path.Attributes.Mandatory | should be $true    
        }
    }
}
