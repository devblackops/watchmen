
InModuleScope Watchmen {

    describe 'Version' {

        Mock -CommandName Assert-InWatchmen -MockWith {}

        it 'Creates a [Version] entry in the Watchmen variable' {
            $global:watchmen = @{
                ThisTest = @{
                    Version = $null
                }
            }
            Version '0.1.0'
            $global:watchmen.ThisTest.Version | should be '0.1.0'
        }
    }
}
