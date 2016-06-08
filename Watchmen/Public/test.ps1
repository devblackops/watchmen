function test {    
    param(
        [string]$Test = '*'
    )
    
    $script:ThisModule.Test = $Test
}
