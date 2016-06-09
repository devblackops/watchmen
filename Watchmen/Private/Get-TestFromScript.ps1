function Get-TestFromScript {
    param (
        [string]$scriptPath
    )

    $errs = $null
    $tok =[System.Management.Automation.PSParser]::Tokenize((get-content -read 0 -Path $scriptPath), [ref]$Errs)
    #write-verbose -Message $scriptPath

    for($i = 0; $i -lt $tok.count; $i++) {
        if ( $tok[$i].type -eq "Command" -and $tok[$i].content -eq "Describe" ) {
            $i++
            if ( $tok[$i].Type -eq "String" ) {
                $tok[$i].Content
            } else {
                # ok - we didn't get the describe text first, 
                # we likely saw a "-Tags" statement, so that means that
                # the describe text will immediately preceed the scriptblock
                while($tok[$i].Type -ne "GroupStart") {
                    $i++
                }
                $i--
                $tok[$i].Content
            }
        }
    }
}
