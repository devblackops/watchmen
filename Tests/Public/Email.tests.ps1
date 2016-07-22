
InModuleScope Watchmen {

    describe 'Email' {

        Mock -CommandName Assert-InWatchmen -MockWith {}

        it 'Returns a [Watchmen.Notifier.Email] object' {
          
            $secPass = 'secret' | ConvertTo-SecureString -AsPlainText -Force
            $cred = New-Object System.Management.Automation.PSCredential -ArgumentList ('user', $secPass)

            $e = @{
                Name = 'test-email'
                FromAddress = 'noreply@example.com'
                Subject = 'Test email object'
                Message = 'This is messate'
                SmtpServer = 'smtp.mydomain.tld'
                Port = 25
                Credential = $cred 
                UseSSL = $false
                To = 'noreply@example.com'
            }
            $o = Email -Options $e
            $o.PSObject.TypeNames -contains 'Watchmen.Notifier.Email' | should be $true
        }

        it 'Should require the -Options parameter' {
            $func = Get-Command -Name Email
            $func.Parameters.Options.Attributes.Mandatory | should be $true    
        }
    }
}