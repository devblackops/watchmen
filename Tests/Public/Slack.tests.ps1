
InModuleScope Watchmen {

    describe 'Slack' {

        Mock -CommandName Assert-InWatchmen -MockWith {}

        it 'Returns a [Watchmen.Notifier.Slack] object' {                    
            $s = @{
                AuthorName = 'Watchmen'
                PreText = 'Everything is on :fire:'
                Token = 'secrettoken'
                Channel = '#Watchmen'
                IconUrl = 'www.google.com'
                IconEmoji = ':fire:'
            }
            $o = Slack -Options $s
            $o.PSObject.TypeNames -contains 'Watchmen.Notifier.Slack' | should be $true
        }

        it 'Should require the -Options parameter' {
            $func = Get-Command -Name Slack
            $func.Parameters.Options.Attributes.Mandatory | should be $true    
        }
    }
}
