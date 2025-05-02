# Define hostname or IP to check
$hostName = "myhost.domain.com"

# Define services using the shared hostname
$services = @(
    @{ Name = "pfSense SSH"; Host = $hostName; Port = 22 },
    @{ Name = "pfSense HTTPS"; Host = $hostName; Port = 443 },
    @{ Name = "Camera RTSP"; Host = $hostName; Port = 554 },
    @{ Name = "Camera WebUI"; Host = $hostName; Port = 34891 }
)

# Test each service
foreach ($svc in $services) {
    $duration = Measure-Command {
        try {
            $tcp = New-Object System.Net.Sockets.TcpClient
            $tcp.Connect($svc.Host, $svc.Port)
            $tcp.Close()
            $success = $true
        } catch {
            $success = $false
        }
    }

    Write-Host "$($svc.Name) - $($svc.Host):$($svc.Port) - Success: $success - Time: $($duration.TotalMilliseconds) ms"
}
