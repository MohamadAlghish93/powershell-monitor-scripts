[void][System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")
$jsonserial = New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer
$jsonserial.MaxJsonLength = [int]::MaxValue

# Information
$PowerShellObject = $jsonserial.DeserializeObject($(Get-Content -Path 'information.json'))

echo $PowerShellObject 

# Get total and available physical memory
$memory = Get-WmiObject -Class Win32_OperatingSystem
$totalMemoryGB = [math]::Round($memory.TotalVisibleMemorySize / 1MB, 2) # Convert KB to GB
$freeMemoryGB = [math]::Round($memory.FreePhysicalMemory / 1MB, 2) # Convert KB to GB
$usedMemoryGB = [math]::Round($totalMemoryGB - $freeMemoryGB, 2)

# Get CPU usage
$cpuUsage = Get-Counter '\Processor(_Total)\% Processor Time'
$currentCpuUsage = [math]::Round($cpuUsage.CounterSamples.CookedValue, 2)

# Get disk read/write speeds
$diskReadSpeed = Get-Counter '\PhysicalDisk(_Total)\Disk Read Bytes/sec'
$diskWriteSpeed = Get-Counter '\PhysicalDisk(_Total)\Disk Write Bytes/sec'
$readSpeedMBps = [math]::Round($diskReadSpeed.CounterSamples.CookedValue / 1MB, 2) # Convert Bytes/sec to MB/sec
$writeSpeedMBps = [math]::Round($diskWriteSpeed.CounterSamples.CookedValue / 1MB, 2) # Convert Bytes/sec to MB/sec

# Get network read/write speeds
$networkStats = Get-NetAdapterStatistics | Where-Object { $_.Name -eq 'Ethernet' } # Adjust the network adapter name as needed
$networkReadSpeedMbps = [math]::Round($networkStats.ReceivedBytesPerSecond / 1MB * 8, 2) # Convert Bytes/sec to Mbps
$networkWriteSpeedMbps = [math]::Round($networkStats.SentBytesPerSecond / 1MB * 8, 2) # Convert Bytes/sec to Mbps

# Get system uptime and last reboot time
$osInfo = Get-CimInstance -Class Win32_OperatingSystem
$uptime = (Get-Date) - $osInfo.LastBootUpTime
$lastRebootTime = $osInfo.LastBootUpTime

# Get current date and time
$currentDateTime = Get-Date

# Get current user, domain, and computer name
$currentUserName = $env:USERNAME
$currentDomain = $env:USERDOMAIN
$currentComputerName = $env:COMPUTERNAME

# Get hostname and IPv4 address
$hostname = [System.Net.Dns]::GetHostName()
$ipv4Address = [System.Net.Dns]::GetHostAddresses($hostname) | Where-Object { $_.AddressFamily -eq 'InterNetwork' } | Select-Object -ExpandProperty IPAddressToString

# Get operating system
$operatingSystem = Get-CimInstance Win32_OperatingSystem | Select-Object -ExpandProperty Caption


# Get hard disk information
$hardDisks = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | Select-Object DeviceID, VolumeName, @{Name="Size(GB)"; Expression={[math]::Round($_.Size / 1GB, 2)}}, @{Name="FreeSpace(GB)"; Expression={[math]::Round($_.FreeSpace / 1GB, 2)}},@{Name="FreeSpacePercentage"; Expression={[math]::Round(($_.FreeSpace / $_.Size) * 100, 2)}}



# Current date and time
$currentDateTime = Get-Date

# Name of the report creator
$reportCreator = $PowerShellObject.ReportCreator

# Position of the report creator
$reportPosition = $PowerShellObject.ReportPosition

# Logo image URL (replace 'logo.png' with the actual path to your logo image)
$logoImageUrl = $PowerShellObject.LogoImageUrl

# Version information
$version = $PowerShellObject.Version


# Get last event logs errors
$lastErrors = Get-EventLog -LogName System -EntryType Error -Newest 15 | Select-Object TimeGenerated, EntryType, Source, Message

# Check DCOM settings
$dcomSettings = Get-WmiObject Win32_DCOMApplicationSetting

# Check DCOM service status
$dcomService = Get-Service -Name DCOM*
    
# Check if DCOM service is running
if ($dcomService.Status -eq "Running") {
    $serviceStatus = "Running"
} else {
    $serviceStatus = "Stopped"
}


# Define the server and port
$serverDB = $PowerShellObject.Database.Server
$portDP = $PowerShellObject.Database.Port # Example for SQL Server
# Test the connection
$result = Test-NetConnection -ComputerName $serverDB -Port $portDP

# Output the result
if ($result.TcpTestSucceeded) {
    $DatabaseResult = "Connection to $serverDB on port $portDP succeeded."
} else {
    $DatabaseResult = "Connection to $serverDB on port $portDP failed."
}

# Create HTML content
$htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Usage Report</title>
    <style>
       body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .header {
            text-align: center;
            margin-bottom: 20px;
        }
        .header img {
            width: 100px;
            height: 100px;
            margin-bottom: 10px;
        }
        h1 {
            color: #333;
            margin-bottom: 10px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <img src="$logoImageUrl" alt="Logo" width="100" height="100">
        <h1>Health Check Report</h1>
        <p>Report generated by: $reportCreator</p>
        <p>Position: $reportPosition</p>
        <p>Current Date and Time: $currentDateTime</p>
        <p>Version: $version</p>
    </div>
    <h1>System Information Report</h1>
    <table>
        <tr>
            <th>Metric</th>
            <th>Value</th>
        </tr>
        <tr>
            <td>Operating System</td>
            <td>$operatingSystem</td>
        </tr>
        <tr>
            <td>Hostname</td>
            <td>$hostname</td>
        </tr>
        <tr>
            <td>IPv4 Address</td>
            <td>$ipv4Address</td>
        </tr>
        <tr>
            <td>Current Domain</td>
            <td>$currentDomain</td>
        </tr>
        <tr>
            <td>Current User</td>
            <td>$currentUserName</td>
        </tr>
        <tr>
            <td>Current Computer Name</td>
            <td>$currentComputerName</td>
        </tr>
        <tr>
            <td>Current Date and Time</td>
            <td>$currentDateTime</td>
        </tr>
        <tr>
            <td>System Uptime</td>
            <td>$($uptime.Days) days, $($uptime.Hours) hours, $($uptime.Minutes) minutes</td>
        </tr>
        <tr>
            <td>Last Reboot Time</td>
            <td>$lastRebootTime</td>
        </tr>
    </table>
    <h2>Memory Report</h2>
    <table>
        <tr>
            <th>Metric</th>
            <th>Value</th>
        </tr>
        <tr>
            <td>Total Memory</td>
            <td>$totalMemoryGB GB</td>
        </tr>
        <tr>
            <td>Used Memory</td>
            <td>$usedMemoryGB GB</td>
        </tr>
        <tr>
            <td>Free Memory</td>
            <td>$freeMemoryGB GB</td>
        </tr>
    </table>
    <h2>Resources Usage</h2>
    <table>
        <tr>
            <th>Metric</th>
            <th>Value</th>
        </tr>
        <tr>
            <td>CPU Usage</td>
            <td>$currentCpuUsage %</td>
        </tr>
        <tr>
            <td>Disk Read Speed</td>
            <td>$readSpeedMBps MB/s</td>
        </tr>
        <tr>
            <td>Disk Write Speed</td>
            <td>$writeSpeedMBps MB/s</td>
        </tr>
        <tr>
            <td>Network Read Speed</td>
            <td>$networkReadSpeedMbps Mbps</td>
        </tr>
        <tr>
            <td>Network Write Speed</td>
            <td>$networkWriteSpeedMbps Mbps</td>
        </tr>
    </table>
"@

$htmlContent += @"
    <h1>Hard Disks Information</h1>
    <table>
        <tr>
            <th>Drive</th>
            <th>Volume Name</th>
            <th>Size (GB)</th>
            <th>Free Space (GB)</th>
            <th>Free Space (%)</th>
        </tr>
"@



foreach ($disk in $hardDisks) {
    $htmlContent += @"
        <tr>
            <td>$($disk.DeviceID)</td>
            <td>$($disk.VolumeName)</td>
            <td>$($disk.'Size(GB)')</td>
            <td>$($disk.'FreeSpace(GB)')</td>
            <td>$($disk.'FreeSpacePercentage')</td>
        </tr>
"@
}
$htmlContent += @"
    </table>
"@

# Get security Windows updates
$securityUpdates = Get-HotFix | Where-Object { $_.Description -like '*Security Update*' }

$htmlContent += @"
 <h1>Security Windows Updates</h1>
    <table>
        <tr>
            <th>HotFix ID</th>
            <th>Description</th>
            <th>Installed On</th>
        </tr>
"@

foreach ($update in $securityUpdates) {
    $htmlContent += @"
        <tr>
            <td>$($update.HotFixID)</td>
            <td>$($update.Description)</td>
            <td>$($update.InstalledOn)</td>
        </tr>
"@
}

$htmlContent += @"
    </table>
"@

$htmlContent += @"
    </table>
    <h2>Last Event Logs Errors</h2>
    <table>
        <tr>
            <th>Time Generated</th>
            <th>Entry Type</th>
            <th>Source</th>
            <th>Message</th>
        </tr>
"@

foreach ($item in $lastErrors) {
    $htmlContent += @"
        <tr>
            <td>$($item.TimeGenerated)</td>
            <td>$($item.EntryType)</td>
            <td>$($item.Source)</td>
            <td>$($item.Message)</td>
        </tr>
"@
}

$htmlContent += @"
    </table>
"@

$htmlContent += @"
<h1>Tarasol Service</h1>
<table>
    <tr>
        <th>Name</th>
        <th>Status</th>
    </tr>
    <tr>
        <td>DCOM Service Status</td>
        <td>$serviceStatus</td>
    </tr>
</table>
"@


$htmlContent += @"
<h1>Database Connection</h1>
<table>
    <tr>
        <th>Server</th>
        <th>Status</th>
    </tr>
    <tr>
        <td>$($serverDB)</td>
        <td>$DatabaseResult</td>
    </tr>
</table>
"@

$htmlContent += @"
</div>
</body>
</html>
"@


# Define the output file path
$outputFilePath = "SystemUsageReport.html"

# Write HTML content to the file
$htmlContent | Out-File -FilePath $outputFilePath -Encoding UTF8

# Output message to the user
Write-Host "System usage report has been generated and saved to $outputFilePath"
