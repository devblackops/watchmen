
InModuleScope Watchmen {

    describe 'Test' {

        Mock -CommandName Assert-InWatchmen -MockWith {}

        it 'Creates a [Test] entry in the Watchmen variable' {
            $script:watchmen = @{
                ThisTest = @{
                    Test = $null
                }
            }
            Test 'services'
            $script:watchmen.ThisTest.Test | should be 'services'
        }
    }
}
