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
                } else {
                    $files = $item
                }

                foreach ($file in $files) {
                    $tests = @()                    
                    $tests += . $file.FullName

                    $testSet = [pscustomobject]@{
                        PSTypeName = 'Watchmen.TestSet'
                        #Id = $global:WatchMen.CurrentTestSetId - 1
                        Config = $global:watchmen.Config
                        Tests = $tests
                        Notifiers = $global:ThisNotifiers
                    }

                    $global:watchmen.TestSets += $testSet
                    #$global:Watchmen.TestSets[$testSet.Id].Tests += $testSet
                }                        
                
                return $testSet
            }
        } catch {
            throw $_
            # Remove-Variable -Name Watchmen -Scope Global -ErrorAction Ignore
        }
    }
    
    end {
        #Remove-Variable -Name Watchmen -Scope Global -ErrorAction Ignore
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}