#requires -modules poshspec

Import-Module poshspec -Verbose:$false -ErrorAction Stop

describe 'Services' {

    context 'Critical Services' {

        service server status { should be running }

        service workstation status { should be running }

        service eventlog status { should be running }

        service mpssvc status { should be running }

        service winrm status { should be running } 

        service schedule status { should be running }

    }

}