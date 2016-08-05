
InModuleScope Watchmen {

    describe 'FromSource' {

        Mock -CommandName Assert-InWatchmen -MockWith {}

        it 'Creates a [FromSource] entry in the Watchmen variable' {
            $global:watchmen = @{
                ThisTest = @{
                    Source = $null
                }
            }
            FromSource 'PSGallery'
            $global:watchmen.ThisTest.Source | should be 'PSGallery'
        }
    }
}
