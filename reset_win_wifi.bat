@echo off

REM Script resets WiFi interface when it decides to stop working

:loop

ping 192.168.10.1 -n 2 -w 1000 > nul

if errorlevel 1 (
	echo %DATE% %TIME% : WiFi down, resetting..
	netsh interface set interface "Wireless Network Connection" disable
	timeout /T 5 /NOBREAK > null
	netsh interface set interface "Wireless Network Connection" enable
	)

timeout /T 5 /NOBREAK > null

goto loop