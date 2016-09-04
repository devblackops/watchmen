function Slack {
    [cmdletbinding()]
    param(
        [parameter(Mandatory, Position = 0)]
        [hashtable[]]$Options,

        [ValidateSet('Always', 'OnSuccess', 'OnFailure')]
        [string]$When = $script:Watchmen.Options.NotifierConditions.WatchmenTest
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
    }

    process {
        $e = [pscustomobject]@{
            PSTypeName = 'Watchmen.Notifier.Slack'
            Type = 'Slack'
            #Name = $Options.Title
            #Title = $Options.Title
            #TitleLink = $Options.TitleLink
            AuthorName = $Options.AuthorName
            #AuthorIcon = $Options.AuthorIcon
            PreText = $Options.PreText
            Token = $Options.Token
            Channel = $Options.Channel
            IconUrl =$Options.IconUrl
            IconEmoji = $Options.IconEmoji
            Enabled = $true
            NotifierCondition = $When
        }

        return $e
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
