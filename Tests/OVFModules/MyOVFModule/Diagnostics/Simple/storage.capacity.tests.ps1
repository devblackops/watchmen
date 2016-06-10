param(
    $SystemDrive = $env:SystemDrive.Substring(0,1),
    $FreeSystemDriveThreshold = 500,
    $FreeNonSystemDriveThreshold = 500,
    $FreeNonSystemDriveThresholdPct = .05,
    $FreeMemThreshold = 500
)

Describe 'Storage Capacity' {

    Context 'Volumes' {
        $volumes = Get-Volume | where DriveType -eq 'Fixed' 
        it "System drive [$SystemDrive] has $FreeSystemDriveThreshold MB free" {            
            $sysDrive = $volumes | where DriveLetter -eq $SystemDrive
            ($sysDrive.SizeRemaining / 1MB) -ge $FreeSystemDriveThreshold | should be $true
        }
                
        foreach ($volume in $volumes | where DriveLetter -ne $SystemDrive) {
            $driveLetter = $volume.DriveLetter
            it "Non-System drive [$driveLetter] has greater than $FreeNonSystemDriveThreshold MB free" {
                ($volume.SizeRemaining / 1MB) -ge $FreeNonSystemDriveThreshold | should be $true
            }
            
            it "Non-System drive [$driveLetter] has greater than $FreeNonSystemDriveThresholdPct% free" {
                ($volume.SizeRemaining / $volume.Size) -ge $FreeNonSystemDriveThresholdPct | should be $true
            }
        }
    }
}