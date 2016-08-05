
InModuleScope Watchmen {

    describe 'Test' {

        Mock -CommandName Assert-InWatchmen -MockWith {}

        it 'Creates a [Test] entry in the Watchmen variable' {
            $global:watchmen = @{
                ThisTest = @{
                    Test = $null
                }
            }
            Test 'services'
            $global:watchmen.ThisTest.Test | should be 'services'
        }
    }
}
