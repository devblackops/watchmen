function ovftype {    
    param(
        [parameter(Mandatory, Position = 0)]
        [ValidateSet('Simple', 'Comprehensive', 'All')]
        [string]$Type
    )
    
    $script:ThisModule.Type = $Type
}
