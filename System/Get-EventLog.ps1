
Write-Host "Application Event-viewer Error " -ForegroundColor Red
Get-EventLog -LogName Application -After (Get-Date).AddDays(-5) | Where-Object { $_.EntryType -eq 'Error' }

Get-EventLog -LogName Application -After (Get-Date).AddDays(-5) | Where-Object { $_.EntryType -eq 'Error' } |
Add-Member Day -MemberType ScriptProperty -Value { $this.TimeGenerated.ToString('dd.MM.yyyy') } -PassThru |
Group-Object 'Day', 'Source'

Write-Host "************************************************ " -ForegroundColor Yellow

Write-Host "System Event-viewer Error " -ForegroundColor Red
Get-EventLog -LogName System -After (Get-Date).AddDays(-5) | Where-Object { $_.EntryType -eq 'Error' } 

Get-EventLog -LogName System -After (Get-Date).AddDays(-5) | Where-Object { $_.EntryType -eq 'Error' } |
Add-Member Day -MemberType ScriptProperty -Value { $this.TimeGenerated.ToString('dd.MM.yyyy') } -PassThru |
Group-Object 'Day', 'Source'