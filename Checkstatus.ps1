$Cpu = Get-CimInstance -ClassName Win32_Processor
$CpuDataMap = [ordered]@{
    Name = $Cpu.Name
    NumberOfCores = $Cpu.NumberOfCores
    NumberOfLogicalProcessors = $Cpu.NumberOfLogicalProcessors
    MaxClockSpeed = $Cpu.MaxClockSpeed
    CurrentClockSpeed = $Cpu.CurrentClockSpeed
    LoadPercentage = $Cpu.LoadPercentage
}
Write-Output "------------------------------------"
Write-Output "CPU Data"
Write-Output "------------------------------------"
$CpuDataMap.GetEnumerator() | ForEach-Object {
    Write-Output ("{0}: {1}" -f $_.Key, $_.Value)
}
Write-Output "------------------------------------"
Write-Output "Memory Data"
Write-Output "------------------------------------"
$Memmory = Get-CimInstance -ClassName Win32_OperatingSystem 
$MemoryDataMap = [ordered]@{
    TotalMemory = $Memmory.TotalVisibleMemorySize
    FreeMemory = $Memmory.FreePhysicalMemory
    UsedMemory = $Memmory.TotalVisibleMemorySize - $Memmory.FreePhysicalMemory
    ProcentLoad =  ($Memmory.TotalVisibleMemorySize - $Memmory.FreePhysicalMemory) / $Memmory.TotalVisibleMemorySize * 100 
}
$MemoryDataMap.GetEnumerator() | ForEach-Object {
    Write-Output ("{0}: {1}" -f $_.Key, $_.Value)
}

Write-Output "------------------------------------"
Write-Output "Disk Usage"
Write-Output "------------------------------------"
$Disks = Get-CimInstance -ClassName Win32_LogicalDisk

$Disks | ForEach-Object {
    $DiskDataMap = [ordered]@{
        DiskName = $_.DeviceID
        DiskSize = $_.Size
        FreeSpace = $_.FreeSpace
        UsedSpace = $_.Size - $_.FreeSpace
        ProcentLoad = "{0}%" -f (($_.Size - $_.FreeSpace) / $_.Size * 100)
    }

    Write-Output "------------------------------------"
    Write-Output "Disk Data"
    $DiskDataMap.GetEnumerator() | ForEach-Object {
        Write-Output ("{0}: {1}" -f $_.Key, $_.Value)
    }
}
Write-Output "------------------------------------"
Write-Output "Top 5 processes by CPU usage"
Write-Output "------------------------------------"


$CpuProcess = Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 Name, CPU
$CpuProcess | ForEach-Object {
    Write-Output ("{0}: {1}" -f $_.Name, $_.CPU)
}

Write-Output "------------------------------------"
Write-Output "------------------------------------"
Write-Output "Top 5 processes by memory usage"
Write-Output "------------------------------------"
$Memoryprocess = Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 5 Name, @{Name="MemoryMB";Expression={[math]::round($_.WorkingSet64 / 1MB, 2)}}
$Memoryprocess | ForEach-Object {
    Write-Output ("{0}: {1}MB" -f $_.Name, $_.MemoryMB)
}
