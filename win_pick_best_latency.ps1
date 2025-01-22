<#

Tests latency of several hosts and chooses the one with the lowest latency.
Discards any that fail to resolve in DNS or respond to ping (If results not equal to null).
Then sorts by response time and selects that host into a varible which can then be used.

I wrote this my self based on searching for exampels. ChatGPT writes a much better and neater version if asked using a simple prompt. 

#>

$FinalResult = @()
$Servers = @(
#	"badhost.somedomain.nowhere"	# No DNS record test
#	"192.168.254.254"				# Doesnt ping test
	"host1"
	"host2"
	"host3"
	)
	
ForEach ($Server in $Servers) {
	$Results = (Test-Connection $Server -Count 3 -ErrorAction SilentlyContinue | Measure-Object -Property ResponseTime -Average).Average
	if ($Results -NE $null) {
		$FinalResult += New-Object psobject -Property @{
			ServerName = $Server
			Result = $Results
		}
	}
}

$BestServer = $FinalResult | Sort-Object -Property Result | Select-Object -First 1
$BestServerName = $BestServer.ServerName

# Output results to console for testing (uncomment).
# $FinalResult | Format-Table
# $BestAvServerName | Write-Host
