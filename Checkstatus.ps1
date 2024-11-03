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
$Disk = Get-CimInstance -ClassName Win32_LogicalDisk
$DiskDataMap = [ordered]@{
    DiskSize = $Disk.Size
    FreeSpace = $Disk.FreeSpace
    UsedSpace = $Disk.Size - $Disk.FreeSpace
    ProcentLoad = ($Disk.Size - $Disk.FreeSpace) / $Disk.Size * 100
}
$DiskDataMap.GetEnumerator() | ForEach-Object {
    Write-Output ("{0}: {1}" -f $_.Key, $_.Value)
}
#Top 5 processes by CPU usage
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 Name, CPU
#Top 5 processes by Memory usage
Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 5 Name, @{Name="MemoryMB";Expression={[math]::round($_.WorkingSet64 / 1MB, 2)}}
