# Get exclusions for directories, processes, and file extensions
Write-Host "Listing current Defender exclusions..."

# Directory exclusions
$pathExclusions = Get-MpPreference | Select-Object -ExpandProperty ExclusionPath
Write-Host "`nDirectory Exclusions:"
if ($pathExclusions) {
    $pathExclusions | ForEach-Object { Write-Host $_ }
} else {
    Write-Host "No directory exclusions found."
}

# File extension exclusions
$extensionExclusions = Get-MpPreference | Select-Object -ExpandProperty ExclusionExtension
Write-Host "`nFile Extension Exclusions:"
if ($extensionExclusions) {
    $extensionExclusions | ForEach-Object { Write-Host $_ }
} else {
    Write-Host "No file extension exclusions found."
}

# Process exclusions
$processExclusions = Get-MpPreference | Select-Object -ExpandProperty ExclusionProcess
Write-Host "`nProcess Exclusions:"
if ($processExclusions) {
    $processExclusions | ForEach-Object { Write-Host $_ }
} else {
    Write-Host "No process exclusions found."
}
