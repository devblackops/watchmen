Import-Module poshspec -Verbose:$false -ErrorAction Stop

describe 'More services' {
    context 'Important Services' {
        service winrm status { should be running } 

        service schedule status { should be running }
    }
}
