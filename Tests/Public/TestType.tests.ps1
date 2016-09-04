
InModuleScope Watchmen {

    describe 'TestType' {

        Mock -CommandName Assert-InWatchmen -MockWith {}

        it 'Creates a [TestType] entry in the Watchmen variable' {
            $script:watchmen = @{
                ThisTest = @{
                    TestType = $null
                }
            }
            TestType 'simple'
            $script:watchmen.ThisTest.Type | should be 'simple'
        }
    }
}
