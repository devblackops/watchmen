
InModuleScope Watchmen {

    describe 'Parameters' {

        Mock -CommandName Assert-InWatchmen -MockWith {}

        it 'Creates a [Parameters] entry in the Watchmen variable' {
            $script:watchmen = @{
                ThisTest = @{
                    Parameters = $null
                }
            }
            Parameters @{ foo = 'bar' }
            $script:watchmen.ThisTest.Parameters.foo | should be 'bar'
        }
    }
}
