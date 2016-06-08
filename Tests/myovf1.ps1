ovftest 'asdf' {
    version 0.1.0
    ovftype 'simple'
    test 'storage.capacity'
    fromsource 'psgallery'
    parameters @{
        x = 'asdf'
    }
}

ovftest 'mymodule' {
    version 1.6.0
    ovftype 'comprehensive'
    test 'myapp.tests'
    fromsource 'psgallery'
    parameters @{
        abc = 123
    }
}

