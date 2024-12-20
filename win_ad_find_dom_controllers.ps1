# One liner to list domain controller(s) name, IP, OS and Site.
Get-ADDomainController -Filter * | Select-Object Name, IPv4Address, OperatingSystem, Site | Sort-Object Name
