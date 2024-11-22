# Define variables for exclusions
$defaultConfigDir = "$env:ProgramData\Microsoft\Windows\Hyper-V"
$defaultVHDDir = "$env:PUBLIC\Documents\Hyper-V\Virtual Hard Disks"
$defaultSnapshotsDir = "$env:SystemDrive\ProgramData\Microsoft\Windows\Hyper-V\Snapshots"
$defaultClusterStorageDir = "C:\ClusterStorage"

# Define process exclusions
$processes = @(
    "$env:SystemRoot\System32\Vmms.exe",
    "$env:SystemRoot\System32\Vmwps.exe",
    "$env:SystemRoot\System32\Vmcompute.exe",
    "$env:SystemRoot\System32\Vmsp.exe"
)

# Define extensions for file exclusions
$fileExtensions = @("*.vhd", "*.vhdx", "*.avhd", "*.avhdx", "*.vhds", "*.vhdpmem",
    "*.iso", "*.rct", "*.mrt", "*.vsv", "*.bin", "*.xml", "*.vmcx", "*.vmrs", "*.vmgs")

# Add directory exclusions
$directories = @(
    $defaultConfigDir,
    $defaultVHDDir,
    $defaultSnapshotsDir,
    $defaultClusterStorageDir
)

# Function to add exclusions to Windows Defender
function Add-HyperVExclusions {
    param (
        [string[]]$Dirs,
        [string[]]$Exts,
        [string[]]$Procs
    )
    
    foreach ($dir in $Dirs) {
        Write-Host "Adding directory exclusion: $dir"
        Add-MpPreference -ExclusionPath $dir -ErrorAction SilentlyContinue
    }

    foreach ($ext in $Exts) {
        Write-Host "Adding file exclusion for extension: $ext"
        Add-MpPreference -ExclusionExtension $ext -ErrorAction SilentlyContinue
    }

    foreach ($proc in $Procs) {
        Write-Host "Adding process exclusion: $proc"
        Add-MpPreference -ExclusionProcess $proc -ErrorAction SilentlyContinue
    }
}

# Adding exclusions
Add-HyperVExclusions -Dirs $directories -Exts $fileExtensions -Procs $processes

# Additional note for custom directories or replication paths
Write-Host "Remember to manually add custom VM configuration, VHD, and replication directories if applicable."
