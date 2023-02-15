# Get operating system information
$os = get-wmiobject -class win32_operatingsystem

# Get computer system information
$mainboard = get-wmiobject -class win32_baseboard

# Get processor information
$processor = get-wmiobject -class win32_processor

# Get memory capacity and frequency
$memory = get-wmiobject -class win32_physicalmemory
$total_memory = 0
$memory | foreach-object { $total_memory += $_.capacity }
$total_memory_gb = "{0:n2}" -f ($total_memory / 1gb)
$memory_speed = ($memory[0].speed / 1000)

# Get number of memory slots used
$slots = get-wmiobject -class win32_physicalmemoryarray
$slots_used = ($memory | group-object -property banklabel).count

# Get logical disk information
$logicaldiskinfo = get-wmiobject -class  win32_logicaldisk

# Convert size and free space to gb
foreach ($disk in $logicaldiskinfo) {
$disk.Size = [math]::Round($disk.Size / 1GB, 2)
$disk.FreeSpace = [math]::Round($disk.FreeSpace / 1GB, 2)
}

# Get gpu information
$gpu = get-wmiobject -class win32_videocontroller

# Get bios information
$bios = get-wmiobject -class win32_bios

# Output results
"Operating System:
$($os.caption) $($os.osarchitecture)"
"`n"
"Mainboard
Manufacturer: $($mainboard.manufacturer)
Model: $($mainboard.product) $($mainboard.model)
Serial number: $($mainboard.serialnumber)"
"`n"
"Processor (CPU)
Name: $($processor.name)
Socket: $($processor.socketdesignation)
Architecture: $($processor.caption)
Maximum clock speed: $($processor.maxclockspeed) MHz"
"`n"
"Memory (RAM)
Total capacity: $total_memory_gb GB
Speeds: 1: $($memory[0].speed) MHz $(if ($memory[1]) {"2: $($memory[1].speed) MHz"}) $(if ($memory[2]) {"3: $($memory[2].speed) MHz"}) $(if ($memory[3]) {"4: $($memory[3].speed) MHz"}) $(if ($memory[4]) {"5: $($memory[4].speed) MHz"}) $(if ($memory[5]) {"6: $($memory[5].speed) MHz"}) $(if ($memory[6]) {"7: $($memory[6].speed) MHz"}) $(if ($memory[7]) {"8: $($memory[7].speed) MHz"})
Slots used: $slots_used out of $($slots.memorydevices)
Manufacturer: 1: $($memory[0].manufacturer) $(if ($memory[1]) {"2: $($memory[1].manufacturer)"}) $(if ($memory[2]) {"3: $($memory[2].manufacturer)"}) $(if ($memory[3]) {"4: $($memory[3].manufacturer)"}) $(if ($memory[4]) {"5: $($memory[4].manufacturer)"}) $(if ($memory[5]) {"6: $($memory[5].manufacturer)"}) $(if ($memory[6]) {"7: $($memory[6].manufacturer)"}) $(if ($memory[7]) {"8: $($memory[7].manufacturer)"})
Part number: 1: $($memory[0].partnumber) $(if ($memory[1]) {"2: $($memory[1].partnumber)"}) $(if ($memory[2]) {"3: $($memory[2].partnumber)"}) $(if ($memory[3]) {"4: $($memory[3].partnumber)"}) $(if ($memory[4]) {"5: $($memory[4].partnumber)"}) $(if ($memory[5]) {"6: $($memory[5].partnumber)"}) $(if ($memory[6]) {"7: $($memory[6].partnumber)"}) $(if ($memory[7]) {"8: $($memory[7].partnumber)"})
Serial number: 1: $($memory[0].serialnumber) $(if ($memory[1]) {"2: $($memory[1].serialnumber)"}) $(if ($memory[2]) {"3: $($memory[2].serialnumber)"}) $(if ($memory[3]) {"4: $($memory[3].serialnumber)"}) $(if ($memory[4]) {"5: $($memory[4].serialnumber)"}) $(if ($memory[5]) {"6: $($memory[5].serialnumber)"}) $(if ($memory[6]) {"7: $($memory[6].serialnumber)"}) $(if ($memory[7]) {"8: $($memory[7].serialnumber)"})
Minimum voltage: 1: $($memory[0].minvoltage) $(if ($memory[1]) {"2: $($memory[1].minvoltage)"}) $(if ($memory[2]) {"3: $($memory[2].minvoltage)"}) $(if ($memory[3]) {"4: $($memory[3].minvoltage)"}) $(if ($memory[4]) {"5: $($memory[4].minvoltage)"}) $(if ($memory[5]) {"6: $($memory[5].minvoltage)"}) $(if ($memory[6]) {"7: $($memory[6].minvoltage)"}) $(if ($memory[7]) {"8: $($memory[7].minvoltage)"})
Maximum voltage: 1: $($memory[0].maxvoltage) $(if ($memory[1]) {"2: $($memory[1].maxvoltage)"}) $(if ($memory[2]) {"3: $($memory[2].maxvoltage)"}) $(if ($memory[3]) {"4: $($memory[3].maxvoltage)"}) $(if ($memory[4]) {"5: $($memory[4].maxvoltage)"}) $(if ($memory[5]) {"6: $($memory[5].maxvoltage)"}) $(if ($memory[6]) {"7: $($memory[6].maxvoltage)"}) $(if ($memory[7]) {"8: $($memory[7].maxvoltage)"})"
"`n"
"Logical disk information: $($logicaldiskinfo | select-object DeviceID, VolumeName, Size, Freespace | format-table | out-string)"
"Graphics card (GPU):
$($gpu.name)"
"`n"
"BIOS: $($bios.manufacturer) $($bios.version) $($bios.name)"
"`n"

# Exiting prompt
read-host -prompt "Press Enter to exit"