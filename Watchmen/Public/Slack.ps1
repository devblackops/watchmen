function Slack {
    [cmdletbinding(DefaultParameterSetName = 'options')]
    param(
        [parameter(Mandatory, Position = 0, ParameterSetName = 'bool')]
        [bool]$Enable,

        [parameter(Mandatory, Position = 0, ParameterSetName = 'options')]
        [hashtable[]]$Options
    )
    
    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
    }
    
    process {
        $e = [pscustomobject]@{
            PSTypeName = 'Watchmen.Notifier.Slack'
            Type = 'Slack'
            Title = ''
            TitleLink = ''
            Author = ''
            AuthorIcon = ''
            Token = ''
            Channel = ''
            IconUrl = ''
            IconEmoji = ''
            Enabled = $true
        }

        if ($PSCmdlet.ParameterSetName -eq 'bool') {
            # We were only passed a [bool] to enable/disable the Slack notifiaction so we're assuming
            # somewhere before this we have specifed additional Slack parameters inside a WatchmenOptions
            # block. Merge in those values

            if ($global:Watchmen.Config.NotifierOptions.Slack) {
                $e.Title = $global:Watchmen.Config.NotifierOptions.Slack.Title
                $e.TitleLink = $global:Watchmen.Config.NotifierOptions.Slack.TitleLink
                $e.Author = $global:Watchmen.Config.NotifierOptions.Slack.Author
                $e.AuthorIcon = $global:Watchmen.Config.NotifierOptions.Slack.AuthorIcon
                $e.Token = $global:Watchmen.Config.NotifierOptions.Slack.Token
                $e.Channel = $global:Watchmen.Config.NotifierOptions.Slack.Channel
                $e.IconUrl = $global:Watchmen.Config.NotifierOptions.Slack.IconUrl
                $e.IconEmoji = $global:Watchmen.Config.NotifierOptions.Slack.IconEmoji
                if (-not $Enable) {
                    $e.Enabled = $false
                } 
            } else {
                throw 'No Slack options have been specified in WatchmenOptions!'
            }
        } else {
            Write-Debug -Message 'Slack options specified'
            $e.Title = $Options.Title
            $e.TitleLink = $Options.TitleLink
            $e.Author = $Options.Author
            $e.AuthorIcon = $Options.AuthorIcon
            $e.Token = $Options.Token
            $e.Channel = $Options.Channel
            $e.IconUrl = $Options.IconUrl
            $e.IconEmoji = $Options.IconEmoji

            # If 'Slack' was called from inside WatchmenOptions, then persist these settings
            # in the watchmen state for future reference
            if ($global:Watchmen.InConfig) {
                $global:Watchmen.Config.NotifierOptions.Slack = $e
            }
        }

        return $e
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
