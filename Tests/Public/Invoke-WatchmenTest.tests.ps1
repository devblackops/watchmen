
InModuleScope Watchmen {

    $projectRoot = $ENV:BHProjectPath

    describe 'Invoke-WatchmenTest' {

        context 'Single watchmen file' {

            $fakeTest = [pscustomobject]@{
                PSTypeName = 'Watchmen.Test'
                Type = 'all'
                Source = $null
                ModuleName = 'OVF.Example1'
                Version = $null
                Notifiers = @{
                    Email = @{}
                    EventLog = @{}
                    LogFile = @{}
                    PowerShell = @{}
                    Slack = @{}
                    Syslog = @{}
                }
                Test = '*'
                Parameters = @{}
            }

            $fakeTestInfo = [pscustomobject]@{
                PSTypeName = 'Operation.Validation.Info'
                File = 'storage.capacity.tests.ps1'
                FilePath = 'C:\Program Files\WindowsPowerShell\Modules\OVF.Example1\Diagnostics\Simple\storage.capacity.tests.ps1'
                ModuleName = 'C:\Program Files\WindowsPowerShell\Modules\OVF.Example1'
                Name = @('Storage Capacity')
                TestCases = $null
                Type = 'Simple'
            }

            $fakeTestResult = [pscustomobject]@{
                PSTypeName = 'Operation.Validation.Result'
                Error = $null
                FileName = 'C:\Program Files\WindowsPowerShell\Modules\OVF.Example1\Diagnostics\Simple\storage.capacity.tests.ps1'
                Module = 'OVF.Example1'
                Name = 'Storage Capacity:Volumes:System volume [C] has greater than [500] MB free'
                RawResult = @{}
                Result = 'Failed'
                ShortName = 'storage.capacity.tests.ps1'
            }

            Mock -CommandName Get-WatchmenTest -MockWith {
                return $fakeTest
            }

            Mock -CommandName Get-OvfTestInfo -MockWith {
                return $fakeTestInfo
            }

            Mock -CommandName Invoke-OvfTest -MockWith {
                return $fakeTestResult
            }

            Mock -CommandName Invoke-WatchmenNotifier -MockWith {}

            $p = "$projectRoot\TestArtifacts\singleovf.watchmen.ps1"

            it 'Accepts passing a Watchmen file by path' {
                Invoke-WatchmenTest -Path $p -WarningAction SilentlyContinue
            }

            it 'Accepts passing a Watchmen file path using the pipeline' {
                $p | Invoke-WatchmenTest -WarningAction SilentlyContinue
            }

            it 'Accepts passing a Watchmen test object' {
                Invoke-WatchmenTest -InputObject $fakeTest -WarningAction SilentlyContinue
            }

            it 'Accepts passing a Watchmen test object using the pipeline' {
                $fakeTest | Invoke-WatchmenTest -WarningAction SilentlyContinue
            }

            it 'Passes test results back' {
                $r = $p | Invoke-WatchmenTest -PassThru -WarningAction SilentlyContinue
                $r | should not benullorempty
            }
        
            it 'Ran a failing test and executed the notifier(s)' {
                $p | Invoke-WatchmenTest -WarningAction SilentlyContinue
                Assert-MockCalled -CommandName Invoke-WatchmenNotifier
            }

            it 'Does not run notifiers when -DisableNotifiers is used' {
                $p | Invoke-WatchmenTest -DisableNotifiers -WarningAction SilentlyContinue
                Assert-MockCalled -CommandName Invoke-WatchmenNotifier -Times 0 -Scope It
            }
        }        
    }
}
