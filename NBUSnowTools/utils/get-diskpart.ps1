

function get-diskpart {
    <#
      .SYNOPSIS
      Report Storage Usage on specified host   
   
      .DESCRIPTION
      Diskpart - Disk Details for volume identification / verification    
     
      .EXAMPLE
      get-diskpart -target computername -disknum 1 
    
      .NOTES
          AUTHOR: Rob Slaughter ( System Administrator Ramsay Health Care )
          Email: slaughterr@ramsayhealth.com.au
          LASTEDIT: 26/10/2022 19:13:11
   
     .LINK
          
  #>
    
  Param(
      [Parameter(Mandatory=$true,HelpMessage="Provide a Comptername")]
    [string]$target,
    [Parameter(Mandatory=$true,HelpMessage="Provide a disk number between 0 and ?")]
    [string]$disknum
  )
  
  #
  #gwmi -Class cim_storagevolume -ComputerName $target -Credential $myadmin |ft SystemName,Name,Label, @{N="Capacity GB";E={"{0:n1}" -f ($_.Capacity/1gb)}},@{N="Free GB";E={"{0:n1}" -f ($_.FreeSpace/1gb)}}
  #gwmi -Class cim_diskpartition -ComputerName $target -Credential $myadmin |Select-Object Name, @{N="Size GB";E={"{0:n1}"-f($_.Size /1gb)}}
  icm $target -Credential $myadmin -ScriptBlock { "list disk"|diskpart}
  icm $target -Credential $myadmin -ScriptBlock { "select disk $using:disknum","Detail Disk"|diskpart}
  
}