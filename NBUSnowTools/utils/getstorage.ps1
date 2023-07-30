 function getstorage {
  <#
    .SYNOPSIS
    Report Storage Usage on specified host   
 
    .DESCRIPTION
    Storage Capacity Report ( WMI Query listing volume sizes )    
   
    .EXAMPLE
    getstorage -target computername (Switch -hyperv) to gather scvmm storage report, vmware not currently supported.  
  
    .NOTES
        AUTHOR: Rob Slaughter ( System Administrator Ramsay Health Care )
        Email: slaughterr@ramsayhealth.com.au
        LASTEDIT: 26/10/2022 19:13:11
 
   .LINK
        
#>
  
Param(
    [Parameter(Mandatory=$true,HelpMessage="Provide a Comptername")]
  [string]$target,
  [switch]$hyperv
)


gwmi -Class cim_storagevolume -ComputerName $target -Credential $myadmin |ft SystemName,Name,Label, @{N="Capacity GB";E={"{0:n1}" -f ($_.Capacity/1gb)}},@{N="Free GB";E={"{0:n1}" -f ($_.FreeSpace/1gb)}}
gwmi -Class cim_diskpartition -ComputerName $target -Credential $myadmin |Select-Object Name, @{N="Size GB";E={"{0:n1}"-f($_.Size /1gb)}}
icm $target -Credential $myadmin -ScriptBlock { "list volume"|diskpart}

if($hyperv){ Write-Host -ForegroundColor Cyan "Gathing VHD info" 

$vmms = Read-host {Enter with VMMSite}
if($vmms){
  $vmhost = findvm $target |select vmhost
  Get-SCStorageFileShare -VMMServer $vmms -VMHost $($vmhost).vmhost |select @{N="FreeGB";E={ ($_.FreeSpace)/1gb }}, SharePath |tee -variable global:worknotes
  Get-SCStorageFileShare -VMMServer caidc20 |?{$_.Name -like 'SN*CTR'}|select Name, @{N="Total Cap GB";E={"{0:n1}" -f ($_.Capacity /1gb)}},@{N="Freebe GB";E={"{0:n1}" -f ($_.FreeSpace /1gb)}}
  Get-SCStoragePool -VMMServer $vmms |select Name, @{N="Total Cap GB";E={"{0:n1}" -f ($_.TotalManagedSpace /1gb)}},@{N="Freebe GB";E={"{0:n1}" -f ($_.RemainingManagedSpace /1gb)}}
  Get-SCStorageDisk -VMMServer $vmms |?{$_.VMHost -like '$vmhost*'}|select DiskVolumes, @{N="Total Capacity GB";E={"{0:n1}" -f ($_.Capacity /1gb)}},@{N="Freebie G's";E={"{0:n1}" -f ($_.AvailableCapacity /1gb)}}
  Get-SCStorageVolume -VMMServer $vmms |?{($_.VMHost -like "$vmhost*") -and ($_.VolumeLabel -like 'VirtualData')}|select VMHost, @{N='Free Capacity GB';E={"{0:n1}" -f ($_.Freespace /1gb)}}, @{N="Used GB";E={"{0:n1}" -f ($_.Capacity /1gb) - ($_.Freespace /1gb)}}
  
  $Global:VMStorage = Get-SCVirtualMachine $target -vmms $vmms |Get-SCVirtualHardDisk |Select Name, VHDType, @{N="Size";E={"{0:n1}" -f ($_.MaximumSize /1gb)}} }
  write-host -ForegroundColor Cyan "What do we see: `n $($VMStorage)"
  
  } else { write-host -ForegroundColor Magenta "You didn't supply the CA server."}
  return $($VMStorage)
}
$VMStorage