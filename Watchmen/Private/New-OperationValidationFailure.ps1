function New-OperationValidationFailure {
    param (
        [Parameter(Mandatory=$true)][string]$StackTrace,
        [Parameter(Mandatory=$true)][string]$FailureMessage
    )

    $o = [pscustomobject]@{
        PSTypeName = 'OperationValidationFailure'
        StackTrace = $StackTrace
        FailureMessage = $FailureMessage
    }
    #$o.psobject.Typenames.Insert(0,"OperationValidationFailure")
    $ToString = { return $this.StackTrace }
    Add-Member -Inputobject $o -MemberType ScriptMethod -Name ToString -Value $toString -Force
    $o
}