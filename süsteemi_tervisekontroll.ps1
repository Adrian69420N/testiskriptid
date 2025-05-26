$logFile = "C:\Logs\system_health_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').log"
New-Item -ItemType Directory -Path "C:\Logs" -Force | Out-Null


$cpuLoad = (Get-CimInstance -ClassName Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average
$diskSpace = Get-PSDrive -PSProvider FileSystem | Select-Object Name, Free, Used, @{Name="Total(GB)"; Expression={"{0:N2}" -f ($_.Used + $_.Free)/1GB}}
$memory = Get-CimInstance -ClassName Win32_OperatingSystem


$logContent = @"
[Tervisekontroll] $(Get-Date)
----------------------------------------
CPU koormus: $cpuLoad %
Vaba mälu: {0:N2} MB
Kasutatud mälu: {1:N2} MB
Kokku mälu: {2:N2} MB


Kettaruumid:
$($diskSpace | Out-String)


----------------------------------------
"@ -f ($memory.FreePhysicalMemory / 1KB), (($memory.TotalVisibleMemorySize - $memory.FreePhysicalMemory) / 1KB), ($memory.TotalVisibleMemorySize / 1KB)


$logContent | Out-File -FilePath $logFile -Encoding UTF8
Write-Host "Tervisekontroll salvestatud: $logFile"
