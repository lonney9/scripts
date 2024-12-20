# Telnet client used to be a good way to check if port was open or reachable on a remote host.
# Telnet client is seen as a security risk and is no longer installed by default on Windows, or is even
# prevented from being installed.
# This oneliner will do what telnet used to on Windows Server 2012 R2 and Windows 8.1 or later which have PowerShell 4.
Test-NetConnection -ComputerName <IP or hostname> -Port <Port number>
