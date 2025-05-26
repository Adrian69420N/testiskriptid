# === Tervisekontrolli skript Windowsile ===

# Kuupäevakaustade loomine
$logRoot = "C:\Logs"
$dateStamp = Get-Date -Format "yyyy-MM-dd"
$logPath = Join-Path $logRoot $dateStamp
New-Item -ItemType Directory -Path $logPath -Force | Out-Null

# Failinimi
$timestamp = Get-Date -Format "HH-mm-ss"
$logFile = "$logPath\system_health_$timestamp.log"

# CPU info
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1 Name, NumberOfLogicalProcessors
$cpuLoad = (Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average

# Mälu
$memory = Get-CimInstance Win32_OperatingSystem
$freeMem = [math]::Round($memory.FreePhysicalMemory / 1024, 2)
$totalMem = [math]::Round($memory.TotalVisibleMemorySize / 1024, 2)
$usedMem = [math]::Round($totalMem - $freeMem, 2)

# Kettaruumid
$diskSpace = Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    [PSCustomObject]@{
        Name  = $_.Name
        Free  = "{0:N2}" -f ($_.Free / 1GB)
        Used  = "{0:N2}" -f ($_.Used / 1GB)
        Total = "{0:N2}" -f (($_.Used + $_.Free) / 1GB)
    }
}

# Uptime
$uptime = (Get-Date) - (gcim Win32_OperatingSystem).LastBootUpTime
$uptimeFormatted = "{0:%d} päeva, {0:hh}h {0:mm}min" -f $uptime

# Protsesside arv
$processCount = (Get-Process).Count

# Logi sisu
$logContent = @"
[Tervisekontroll] $(Get-Date -Format "dd.MM.yyyy HH:mm:ss")
------------------------------------------------------------
Protsessor: $($cpu.Name)
Tuumade arv: $($cpu.NumberOfLogicalProcessors)
CPU koormus: $cpuLoad %

Uptime: $uptimeFormatted
Töötavate protsesside arv: $processCount

Vaba mälu: $freeMem MB
Kasutatud mälu: $usedMem MB
Kokku mälu: $totalMem MB

Kettaruumid:
$($diskSpace | Format-Table -AutoSize | Out-String)
------------------------------------------------------------
"@

# UTF-8 BOM salvestus (et Notepad näitaks täpitähti)
$utf8BOM = New-Object System.Text.UTF8Encoding $true
[System.IO.File]::WriteAllText($logFile, $logContent, $utf8BOM)

# Terminaliväljund
Write-Host "`n✅ Tervisekontroll salvestatud:" -ForegroundColor Green
Write-Host $logFile -ForegroundColor Yellow
