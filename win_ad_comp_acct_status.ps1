# Get name, ou, os version, enabled, last login date, password last set.
# Usage: .\CompAccountStatus.ps1 ComputerName
param(
	[string]$P1
	)
Get-ADComputer $P1 -Property Name, CanonicalName, OperatingSystem, Enabled, LastLogonDate, PasswordLastSet | 
Select-Object Name, CanonicalName, OperatingSystem, Enabled, LastLogonDate, PasswordLastSet
