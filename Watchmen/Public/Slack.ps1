function Slack {
    [cmdletbinding()]
    param(
        [parameter(Mandatory, Position = 0)]
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
            Name = $Options.Title
            Title = $Options.Title
            TitleLink = $Options.TitleLink
            Author = $Options.Author
            AuthorIcon = $Options.AuthorIcon
            Token = $Options.Token
            Channel = $Options.Channel
            IconUrl =$Options.IconUrl
            IconEmoji = $Options.IconEmoji
            Enabled = $true
        }

        return $e
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
