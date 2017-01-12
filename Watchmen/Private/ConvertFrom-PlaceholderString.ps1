Function ConvertFrom-PlaceholderString {
    [cmdletbinding()]
    param(
        [parameter(Mandatory, ValueFromPipeline)]
        [string[]]$InputObject,

        [parameter(Mandatory)]
        [ValidateScript({ $_.PSObject.TypeNames[0] -eq 'OperationValidationResult' })]
        [pscustomobject]$Results
    )

    begin {
        Write-Debug -Message "Entering: $($PSCmdlet.MyInvocation.MyCommand.Name)"
        Assert-InWatchmen -Command $PSCmdlet.MyInvocation.MyCommand.Name
    }

    process {

        foreach($string in $InputObject) {
            # replace any variables
            $string = $string.Replace('#{computername}', $env:COMPUTERNAME)
            $string = $string.Replace('#{module}', $results.module)
            $string = $string.Replace('#{file}', $results.FileName)
            $string = $string.Replace('#{describe}', $results.RawResult.Describe)
            $string = $string.Replace('#{context}', $results.RawResult.Context)
            $string = $string.Replace('#{test}', $results.RawResult.Name)
            $string = $string.Replace('#{result}', $results.Result)
            $string = $string.Replace('#{failureMessage}', $results.RawResult.FailureMessage)
            $string = $string.Replace('#{duration}', $results.RawResult.Time.ToString())

            return $string
        }
    }

    end {
        Write-Debug -Message "Exiting: $($PSCmdlet.MyInvocation.MyCommand.Name)"
    }
}
