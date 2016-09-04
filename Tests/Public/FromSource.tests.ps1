
InModuleScope Watchmen {

    describe 'FromSource' {

        Mock -CommandName Assert-InWatchmen -MockWith {}

        it 'Creates a [FromSource] entry in the Watchmen variable' {
            $script:watchmen = @{
                ThisTest = @{
                    Source = $null
                }
            }
            FromSource 'PSGallery'
            $script:watchmen.ThisTest.Source | should be 'PSGallery'
        }
    }
}
