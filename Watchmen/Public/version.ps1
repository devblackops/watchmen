function version {    
    param(
        [parameter(Mandatory, Position = 0)]
        [string]$Version
    )
    
    $script:ThisModule.Version = $Version
}
