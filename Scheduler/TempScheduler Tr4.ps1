
<#try
{
    Unregister-ScheduledTask -TaskName "Tarasol 3. Cleaner" -Confirm:$false
}
catch
{
   
    Write-Host "The ScheduledTask doesn't created yet" -ForegroundColor red -BackgroundColor red
}#>

$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-NoProfile -WindowStyle Hidden -command "& {Get-ChildItem -Path C:\inetpub\wwwroot\TarasolAPI4\TempFolder\ -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-30))} | Remove-Item -Recurse -Force}"';

$trigger =  New-ScheduledTaskTrigger -Daily -At 2am

Register-ScheduledTask -Action $action -Trigger $trigger -TaskPath "NVSSoft" -TaskName "Tarasol 4. Cleaner" -Description "Daily remove temp folder from Tarasol 4.^"