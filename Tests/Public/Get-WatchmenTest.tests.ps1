
$projectRoot = $ENV:BHProjectPath

describe 'Get-WatchmenTest' {

    context 'Single watchmen file' {
        it 'Gets a single Watchmen test' {
            $t = @(Get-WatchmenTest -Path "$projectRoot\TestArtifacts\singleovf.watchmen.ps1")
            $t.Count | should be 1
        }

        it 'Gets a multiple Watchmen tests' {
            $t = Get-WatchmenTest -Path "$projectRoot\TestArtifacts\multipleovf.watchmen.ps1"
            $t.Count | should be 2
        }
    }

    context 'Read all from Folder' {
        it 'Gets Watchmen tests from two files in folder' {
            $t = Get-WatchmenTest -Path "$projectRoot\TestArtifacts"
            $t.Count | Should be 3
        }

        it 'Gets all tests from folder recursively' {
            $t = Get-WatchmenTest -Path "$projectRoot\TestArtifacts" -Recurse
            $t.Count | Should be 4
        }
    }
}
