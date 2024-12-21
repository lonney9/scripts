<#
Purpose:  To check AD for stale computer objects based on PasswordLastSet and disable / delete.
          Uses PasswordLastSet field as this is updated every 30 days when the computer account password
          is automatically changed when the system is online.
          LastLoginDate can go a long time if the system is not regularly logged into.
          Processes computer objects in three steps based on inactivity time:
          Phase 1, disabled and left in place for easy re-enablement (lets not play the OU guessing game).
          Phase 2, Move into zDisabledComputers OU.
          Phase 3, Deleted from zDisabledComputers OU using SearchBase so it cant potentially run amok!
          Script will output accounts it identifies to CSV for review. When you are confident of the results comment out
          the Select-Object line(s) that output to CSV, and uncomment the line below that performs the action on the account.
          Update the OU paths to suit your environment.
#>
 
$AgePhase1 = (Get-Date).AddDays(-180)
$AgePhase2 = (Get-Date).AddDays(-240)
$AgePhase3 = (Get-Date).AddDays(-300)
 
# Phase 1 - Disable old computer objects: 
Get-ADComputer -Properties Name, PasswordLastSet -Filter {(Enabled -eq $True) -AND (PasswordLastSet -lt $AgePhase1)} |
Select-Object Name, PasswordLastSet | Export-Csv -NoTypeInformation .\StaleComputersP1.csv
# Set-ADComputer -Enabled $false 
 
# Phase 2 - Move slightly older computer objects: 
Get-ADComputer -Properties Name, PasswordLastSet -Filter {(Enabled -eq $False) -AND (PasswordLastSet -lt $AgePhase2)} |
Select-Object Name, PasswordLastSet | Export-Csv -NoTypeInformation .\StaleComputersP2.csv
# Move-ADObject -TargetPath "OU=zDisabledComputers,DC=contoso,DC=com"

# Phase 3 - Delete really old computer objects:
Get-ADComputer -SearchBase "OU=zDisabledComputers,DC=contoso,DC=com" -Properties Name, PasswordLastSet -Filter {PasswordLastSet -lt $AgePhase3} |
Select-Object Name, PasswordLastSet | Export-Csv -NoTypeInformation .\StaleComputersP3.csv
# Remove-ADComputer -Confirm:$false
