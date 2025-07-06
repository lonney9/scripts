<#

Tests latency of several hosts and chooses the one with the lowest latency.
Discards any that fail to resolve in DNS or respond to ping (If results not equal to null).
Selects the best host into a varible which can then be used.

This is the version ChatGPT wrote.
    Added the option for an input file (used if found).
    Neater logic to find the best host.

## Not fully tested yet ## 

#>

# Define optional input file
$hostFile = ".\hosts.txt"

# Load from file if available
if (Test-Path $hostFile) {
    Write-Host "Loading hosts from file: $hostFile"
    $Servers = Get-Content $hostFile
} else {
    Write-Host "No host file found. Using default hardcoded list."
    $Servers = @(
        # "badhost.somedomain.nowhere"
        # "192.168.254.254"
        "8.8.8.8",
        "1.1.1.1",
        "example.com",
        "localhost"
    )
}

# Initialize best host tracking
$bestHost = $null
$lowestLatency = [double]::MaxValue

foreach ($server in $Servers) {
    $server = $server.Trim()
    if (-not $server) { continue }

    # Send 1 ping, quietly
    $ping = Test-Connection -ComputerName $server -Count 1 -ErrorAction SilentlyContinue

    if ($ping) {
        $latency = $ping.ResponseTime
        Write-Host "Checked $server - $latency ms"

        if ($latency -lt $lowestLatency) {
            $lowestLatency = $latency
            $bestHost = $server
        }
    } else {
        Write-Host "Failed to reach $server"
    }
}

# Final output
if ($bestHost) {
    Write-Host "`nBest host: $bestHost with $lowestLatency ms"
} else {
    Write-Host "`nNo reachable hosts found."
}
