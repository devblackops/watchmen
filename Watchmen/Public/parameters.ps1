function parameters {    
    param(
        [Parameter(Mandatory)]
        [hashtable]$Parameters
    )
    
    $script:ThisModule.Parameters = $Parameters
}
