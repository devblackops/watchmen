function InfluxDB {
    [cmdletbinding()]
    param(
        [parameter(Mandatory, Position = 0)]
        [hashtable]$Options,

        [ValidateSet('Always', 'OnSuccess', 'OnFailure')]
        [string]$When = $script:Watchmen.Options.NotifierConditions.WatchmenTest
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
    }

    process {
        $i = [pscustomobject]@{
            PSTypeName = 'Watchmen.Notifier.InfluxDB'
            Type = 'InfluxDB'
            Url = $Options.Url
            Port = 8086
            Database = $Options.Database
            MeasurementName = 'watchmen_test'
            Tags = @{}
            RetentionPolicy = [string]::Empty
            WriteConsistency = [string]::Empty
            Timeout = 5
            Credential = $null
            UserAgent = 'Watchmen'
            Enabled = $true
            SkipSSLVerification = $false
            NotifierCondition = $When
        }

        $reservedTags = @('context', 'describe', 'filename', 'module', 'test')

        # Optional settings
        if ($Options.Port) { $i.Port = $Options.Port }
        if ($Options.MeasurementName) { $i.MeasurementName = $Options.MeasurementName }
        if ($Options.Tags) {
            foreach ($tag in $Options.Tags.Keys) {
                if ($reservedTags -contains $tag) {
                    Throw "Tag [$tag] has already been specified. Cannot overwrite reserved tags [context, describe, filename, module, test]"
                } else {
                    $i.Tags.$tag = $Options.Tags[$tag]
                }
            }
        }
        if ($Options.RetentionPolicy) { $i.RetentionPolicy = $Options.RetentionPolicy }
        if ($Options.WriteConsistency) { $i.WriteConsistency = $Options.WriteConsistency }
        if ($Options.Timeout) { $i.Timeout = $Options.Timeout }
        if ($Options.Credential) { $i.Credential = $Options.Credential }
        if ($Options.SkipSSLVerification) { $i.SkipSSLVerification = $Options.SkipSSLVerification }       

        return $i
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
