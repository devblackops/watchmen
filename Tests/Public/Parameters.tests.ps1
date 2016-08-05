
InModuleScope Watchmen {

    describe 'Parameters' {

        Mock -CommandName Assert-InWatchmen -MockWith {}

        it 'Creates a [Parameters] entry in the Watchmen variable' {
            $global:watchmen = @{
                ThisTest = @{
                    Parameters = $null
                }
            }
            Parameters @{ foo = 'bar' }
            $global:watchmen.ThisTest.Parameters.foo | should be 'bar'
        }
    }
}
