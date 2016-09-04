
InModuleScope Watchmen {

    describe 'When' {

        context 'In WatchmenOptions' {

            Mock -CommandName Assert-InWatchmen -MockWith {}

            BeforeEach {
                $global:watchmen = @{
                    InConfig = $true
                    InTest = $false
                    Options = @{
                        NotifierConditions = @{
                            WatchmenOptions = 'OnFailure'
                            WatchmenTest = 'OnFailure'
                        }
                    }
                }
            }

            it 'Sets the default notifier condition to [OnFailure]' {
                When 'OnFailure'
                $global:Watchmen.Options.NotifierConditions.WatchmenOptions | should be 'Onfailure'
                $global:Watchmen.Options.NotifierConditions.WatchmenTest | should be 'Onfailure'
            }

            it 'Sets the default notifier condition to [OnSuccess]' {
                When 'OnSuccess'
                $global:Watchmen.Options.NotifierConditions.WatchmenOptions | should be 'OnSuccess'
                $global:Watchmen.Options.NotifierConditions.WatchmenTest | should be 'OnSuccess'
            }

            it 'Sets the default notifier condition to [Always]' {
                When 'Always'
                $global:Watchmen.Options.NotifierConditions.WatchmenOptions | should be 'Always'
                $global:Watchmen.Options.NotifierConditions.WatchmenTest | should be 'Always'
            }
        }

        context 'In WatchmenTest' {

            Mock -CommandName Assert-InWatchmen -MockWith {}

            BeforeEach {
                $global:watchmen = @{
                    InConfig = $false
                    InTest = $true
                    Options = @{
                        NotifierConditions = @{
                            WatchmenOptions = 'OnFailure'
                            WatchmenTest = 'OnFailure'
                        }
                    }
                }
            }

            it 'Sets the default notifier condition to [OnFailure]' {
                When 'OnFailure'
                $global:Watchmen.Options.NotifierConditions.WatchmenTest | should be 'Onfailure'
            }

            it 'Sets the default notifier condition to [OnSuccess]' {
                When 'OnSuccess'
                $global:Watchmen.Options.NotifierConditions.WatchmenTest | should be 'OnSuccess'
            }

            it 'Sets the default notifier condition to [Always]' {
                When 'Always'
                $global:Watchmen.Options.NotifierConditions.WatchmenTest | should be 'Always'
            }
        }        
    }
}
