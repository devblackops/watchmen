function ovftest {
    [cmdletbinding(DefaultParameterSetName = 'NoName')]
    param(
        [parameter( ParameterSetName = 'Name', Position = 0)]
        [string]$Name = (New-Guid).ToString(),
                
        [parameter( ParameterSetName = 'Name', Position = 1, Mandatory = $True)]
        [parameter( ParameterSetName = 'NoName', Position = 0, Mandatory = $True)]
        [scriptblock]$Script    
    )
    
    $script:ThisModule = @{
        ModuleName = $Name
        parameters = @{}
        Source = $null        
        Test = '*'
        #Type = 'all'        
        Version = $null
    }
    
    . $Script
    $obj = [pscustomobject]$script:ThisModule
    
    Remove-Variable -Name ThisModule -Scope Script
    #return $options
    return $obj
}