function PowerShell {
    [cmdletbinding(DefaultParameterSetName = 'ScriptBlock')]
    param(
        [parameter(Mandatory, Position = 0, ParameterSetName = 'ScriptBlock')]
        [scriptblock]$ScriptBlock,

        #[ValidateScript({Test-Path $_})]
        [parameter(Mandatory, Position = 0, ParameterSetName = 'script')]
        [string]$Path,

        [parameter(Position = 1)]
        [ValidateSet('Always', 'OnSuccess', 'OnFailure')]
        [string]$When = $script:Watchmen.Options.NotifierConditions.WatchmenTest
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
    }

    process {
        $p = [pscustomobject]@{
            PSTypeName = 'Watchmen.Notifier.PowerShell'
            Type = 'PowerShell'
            ScriptBlock = $null
            ScriptPath = $null
            Enabled = $true
            NotifierCondition = $When
        }

        if ($PSCmdlet.ParameterSetName -eq 'ScriptBlock') {
            $p.ScriptBlock = $ScriptBlock
        } else {
            $resolvedPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)

            # Is PowerShell script relative or absolute?
            if ([System.IO.Path]::IsPathRooted($path)) {
                $file = Get-Item -Path $resolvedPath
            } else {
                $file = Get-Item -Path (Join-Path -Path $script:Watchmen.CurrentWatchmenFileRoot -ChildPath $Path)
            }

            if (-not $file.PSIsContainer) {
                $p.ScriptPath = $file.FullName
            } else {
                Write-Error -Message "PowerShell script path must be a file, not a folder. [$($file.FullName)]"
            }
        }

        return $p
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
