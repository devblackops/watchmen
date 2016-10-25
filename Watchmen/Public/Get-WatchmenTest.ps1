function Get-WatchmenTest {
    [cmdletbinding()]
    param(
        [parameter(Mandatory, ValueFromPipeline)]
        [ValidateScript({Test-Path $_})]
        [string[]]$Path = (Get-Location).Path,

        [switch]$Recurse
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Initialize-Watchmen
    }

    process {
        try {
            foreach ($loc in $path) {
                $item = Get-Item -Path (Resolve-Path $loc)
                if ($item.PSIsContainer) {
                    $files = Get-ChildItem -Path $item -Filter '*.watchmen.ps1' -Recurse:$Recurse
                    $script:watchmen.CurrentWatchmenFileRoot = $item.FullName
                } else {
                    $files = $item
                    $script:watchmen.CurrentWatchmenFileRoot = $item.Directory
                }

                $tests = @()
                foreach ($file in $files) {
                    Write-Verbose -Message "Loading Watchmen tests from file [$($file.FullName)]"
                    $fileTests = @()
                    $fileTests += . $file.FullName

                    $tests += $fileTests
                    $script:watchmen.TestSets += $fileTests
                }

                $tests
            }
        } catch {
            throw $_
        }
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
