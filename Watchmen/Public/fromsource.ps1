function fromsource {    
    param(
        [parameter(Mandatory, Position = 0)]
        [string]$Source
    )
    
    $script:ThisModule.Source = $Source
}
