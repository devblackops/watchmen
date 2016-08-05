
$ProjectRoot = $ENV:BHProjectPath

InModuleScope Watchmen {

    describe 'PowerShell' {

        Mock -CommandName Assert-InWatchmen -MockWith {}

        it 'Returns a [Watchmen.Notifier.PowerShell] object using the ScriptBlock parameter set' {
            $sb = {
                Write-Host $args[0]
            }
            $o = PowerShell -ScriptBlock $sb
            $o.PSObject.TypeNames -contains 'Watchmen.Notifier.PowerShell' | should be $true
        }

        it 'Returns a [Watchmen.Notifier.PowerShell] object using the Script parameter set' {
            $o = PowerShell -Path "notify.ps1"
            $o.PSObject.TypeNames -contains 'Watchmen.Notifier.PowerShell' | should be $true
        }

        it 'Should require the -ScriptBlock parameter' {
            $func = Get-Command -Name PowerShell
            $func.Parameters.ScriptBlock.Attributes.Mandatory | should be $true    
        }

        it 'Should require the -Path parameter' {
            $func = Get-Command -Name PowerShell
            $func.Parameters.Path.Attributes.Mandatory | should be $true    
        }
    }
}
