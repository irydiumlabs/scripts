# Hyper-V Defender exclusions for recommended directories, files, and processes.
# Source: Microsoft guidance (KB 3105657 / "Recommended antivirus exclusions for Hyper-V hosts").
# This script adds exclusions for the *default* Hyper-V paths and file types.
# NOTE: Windows Defender may already include some automatic exclusions, but this script
# applies the recommended exclusions explicitly.

# =========================
# REQUIRED EDIT SECTION
# =========================
# If your VMs are not stored in the default paths, you MUST edit $customVmDirs below.
# Add any directories that *contain VM files* (VHD/VHDX/VMRS/VMCX/etc).
# Examples:
#   "D:\HyperV\VMs"
#   "E:\VMStorage"
#   "\\FileServer\VMShare"
# If you use Hyper-V Replica, add the replica storage directory too.
# If your VMs are on SMB 3.0 shares (file servers), add those share paths as well.
$customVmDirs = @(
    # "D:\HyperV\VMs"
)

# Stop if no custom directories are provided (per operator requirement)
if ($customVmDirs.Count -eq 0) {
    Write-Warning "No custom VM directories were provided in `$customVmDirs. Edit this section to include where your VMs are stored, then re-run the script."
    exit 1
}

# Define variables for default exclusions
$defaultConfigDir = "$env:ProgramData\Microsoft\Windows\Hyper-V"
$defaultVHDDir = "$env:PUBLIC\Documents\Hyper-V\Virtual Hard Disks"
$defaultSnapshotsDir = "$env:SystemDrive\ProgramData\Microsoft\Windows\Hyper-V\Snapshots"
$defaultClusterStorageDir = "C:\ClusterStorage"

# Define process exclusions (per Microsoft guidance)
$processes = @(
    "$env:SystemRoot\System32\Vmms.exe",
    "$env:SystemRoot\System32\Vmwp.exe",
    "$env:SystemRoot\System32\Vmcompute.exe",
    "$env:SystemRoot\System32\Vmsp.exe"
)

# Define extensions for file exclusions (these files are used by Hyper-V VMs)
$fileExtensions = @("*.vhd", "*.vhdx", "*.avhd", "*.avhdx", "*.vhds", "*.vhdpmem",
    "*.iso", "*.rct", "*.mrt", "*.vsv", "*.bin", "*.xml", "*.vmcx", "*.vmrs", "*.vmgs")

# Add directory exclusions (defaults + custom)
$directories = @(
    $defaultConfigDir,
    $defaultVHDDir,
    $defaultSnapshotsDir,
    $defaultClusterStorageDir
) + $customVmDirs

# Output custom paths clearly for operators
if ($customVmDirs.Count -gt 0) {
    Write-Host "Custom VM directories configured:"
    foreach ($customDir in $customVmDirs) {
        Write-Host "  - $customDir"
    }
} else {
    Write-Host "Custom VM directories configured: (none)"
}

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

# Friendly reminder for operators
Write-Host "Done. If your VMs are stored outside the default paths, add those directories to `$customVmDirs and re-run this script."
