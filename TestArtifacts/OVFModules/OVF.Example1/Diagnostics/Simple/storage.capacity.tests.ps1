param(
    $SystemDrive = $env:SystemDrive.Substring(0,1),
    $FreeSystemDriveThreshold = 500,
    $FreeNonSystemDriveThreshold = 500,
    $FreeNonSystemDriveThresholdPct = .05,
    $FreeMemThreshold = 500
    #[hashtable]$ConfigurationData = (Import-PowerShellDataFile -Path "$PSScriptRoot\..\..\ConfigurationData.psd1")
)

Describe 'Storage Capacity' {

    Context 'Volumes' {
        
        # Get volumes
        $volumes = Get-Volume | where DriveType -eq 'Fixed'
        $sysDrive = $volumes | where DriveLetter -eq $SystemDrive
        $nonSysDrives = $volumes | ? {
            $_.DriveLetter -ne $SystemDrive -and 
            $_.DriveLetter -ne $null -and $_.FileSystemLabel -ne $null
        }

        # System drive space
        it "System volume [$($sysDrive.DriveLetter)] has greater than [$FreeSystemDriveThreshold] MB free" {                        
            ($sysDrive.SizeRemaining / 1MB) -ge $FreeSystemDriveThreshold | should be $true
        }
                
        # Non-system drive space
        foreach ($volume in $nonSysDrives) {
            $driveLetter = $volume.DriveLetter
            it "Non-System volume [$driveLetter] has greater than [$FreeNonSystemDriveThreshold] MB free" {
                ($volume.SizeRemaining / 1MB) -ge $FreeNonSystemDriveThreshold | should be $true
            }
            
            it "Non-System volume [$driveLetter] has greater than [$FreeNonSystemDriveThresholdPct%] free" {
                ($volume.SizeRemaining / $volume.Size) -ge $FreeNonSystemDriveThresholdPct | should be $true
            }
        }
    }
}
