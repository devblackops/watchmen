
InModuleScope Watchmen {

    describe 'TestType' {

        Mock -CommandName Assert-InWatchmen -MockWith {}

        it 'Creates a [TestType] entry in the Watchmen variable' {
            $global:watchmen = @{
                ThisTest = @{
                    TestType = $null
                }
            }
            TestType 'simple'
            $global:watchmen.ThisTest.Type | should be 'simple'
        }
    }
}
