$Server = Read-Host "Please enter your server name"
$Service = Get-Service -Name HealthService -ComputerName $Server
 
Write-Host "`n1. Stopping the Monitoring Agent service...`n"
 
Stop-Service $Service
 
Write-Host "2. Checking the Monitoring Agent service status:"
 
Write-Host "`nMonitoring Agent service status: "-nonewline; Write-Host $Service.Status -Fore Red
 
Start-Sleep -s 3
 
Write-Host "`n3. Renaming the existing 'Health Service State' folder to 'Health Service State Old' `n"
 
Rename-Item -Path "\\$Server\C$\Program Files\Microsoft Monitoring Agent\Agent\Health Service State" -NewName "Health Service State Old"
 
Write-Host "4. Starting the Monitoring Agent service...`n"
 
Start-Service $Service
 
Start-Sleep -s 3
 
Write-Host "5. Checking the Monitoring Agent service status:"
 
Write-Host "`nMonitoring Agent service status: "-nonewline; Write-Host $Service.Status -Fore Green
 
Write-Host "`n6. Removing the 'Health Service State Old' folder."
 
Remove-Item -Path "\\$Server\C$\Program Files\Microsoft Monitoring Agent\Agent\Health Service State Old" -Recurse
 
Write-Host "`n7. Done!"