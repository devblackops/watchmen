Import-Module poshspec -Verbose:$false -ErrorAction Stop

describe 'Services' {
    context 'Critical Services 1' {
        service server status { should be running }
        service workstation status { should be running }
    }

}

describe 'asdf' {
    context 'Critical Services 2' {
        service eventlog status { should be running }
        service mpssvc status { should be running }
    }
}
