
function Invoke-NotifierInfluxDB {
    [cmdletbinding()]
    param(
        [parameter(Mandatory, ValueFromPipeline)]
        [ValidateScript({ $_.PSObject.TypeNames[0] -eq 'Watchmen.Notifier.InfluxDB' })]
        [pscustomobject]$Notifier,

        [parameter(Mandatory)]
        [ValidateScript({ $_.PSObject.TypeNames[0] -eq 'OperationValidationResult' })]
        [pscustomobject]$Results
    )

    begin {}

    process {
        # InfluxDB needs spaces and commas escaped with '\'
        # https://docs.influxdata.com/influxdb/v0.13/write_protocols/line/#key
        function Escape([string]$value) {
            return $value -replace ' ', '\ ' -replace ',', '\,' -replace '=', '\='
        }

        if ($Notifier.Enabled) {

            $o = ($Notifier | Format-Table -Property * -AutoSize | Out-String)
            Write-Debug -Message "InfluxDB notifier called with options:`n$o"

            # Tags
            $tags = [ordered]@{
                context = Escape($Results.RawResult.Context)
                describe = Escape($Results.RawResult.Describe)
                filename = Escape($Results.ShortName)
                module = Escape($Results.Module)
                test = Escape($Results.RawResult.Name)
                host = ($env:computerName).ToLower()
                fqdn = ([System.Net.Dns]::GetHostByName(($env:computerName)) | Select-Object -ExpandProperty hostname).ToLower()
            }
            # Add any additional tags that may have been specified on the notifier
            if ($Notifier.Tags.Keys.Count -gt 0) {
                foreach ($tag in $Notifier.Tags.Keys) {
                    $tags.$Tag = Escape($Notifier.Tags[$tag])
                }
            }

            # Field values for pass/fail result and test duration
            # Force the value to an integer by appending 'i'
            # https://docs.influxdata.com/influxdb/v0.13/write_protocols/line/#fields
            if ($Results.Result -eq 'Passed') {
                $value = '0i'
            } else {
                $value = '1i'
            }
            $durationMS = $Results.RawResult.Time.TotalMilliseconds

            # Unix time
            $time = [int][double]::Parse($(Get-Date -date (Get-Date).ToUniversalTime()-uformat %s))

            # Create metric string
            $metric = $Notifier.MeasurementName
            foreach ($tag in $tags.Keys) {
                $metric += ",$tag=$($tags[$tag])"
            }
            $metric += " durationMS=$durationMS,value=$value $time"

            Write-Debug -Message "    $metric"

            $url = "$($Notifier.Url)/write?db=$($Notifier.Database)"
            if ($Notifier.RetentionPolicy -ne [string]::Empty) {
                $url += "&rp=$($Notifier.RetentionPolicy)"
            }
            $url += '&precision=s'
            $params = @{
                Uri = $url
                Method = 'Post'
                Body = $metric
                UseBasicParsing = $true
                Timeout = $Notifier.Timeout
                UserAgent = $Notifier.UserAgent
                Verbose = $false
            }
            if ($Notifier.Credential) {
                $params.Credential = $Notifier.Credential
            }
            Invoke-RestMethod @params | Out-Null
        }
    }

    end {}    
}