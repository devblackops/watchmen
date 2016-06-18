WatchmenTest 'MyOVFModule' {
    version 0.1.0
    testType 'simple'
    test 'storage capacity'
    fromsource 'psgallery'
    parameters @{
        FreeSystemDriveThreshold = 50
    }
}