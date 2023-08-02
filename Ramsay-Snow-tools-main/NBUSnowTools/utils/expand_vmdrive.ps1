
function expand_vmdrive {
	<#
        .SYNOPSIS
        List and expands HyperV VM Disks   
     
        .DESCRIPTION
        HyperV VM Disk Expanding Tool
       
        .EXAMPLE
        expand_vmdrive -vmname myvm -vmmserver myvmmserver
      
        .NOTES
            AUTHOR: Rob Slaughter ( System Administrator Ramsay Health Care )
            Email: slaughterr@ramsayhealth.com.au
            LASTEDIT: 09/05/2022 - 8:47 PM
     
       .LINK
            
    #>
	
	[CmdletBinding()]
	param(

		[Parameter(Mandatory = $true,HelpMessage="Enter a VM dipstick..")]
        [string]
		$vmname = "",
		[Parameter(Mandatory = $false)]
        [string]
        [ValidateSet("caidc02","caidc20")]
		$vmms = ""
	)
	[string]${CmdLetName} = $PSCmdlet.MyInvocation.MyCommand.Name
	Write-FunctionHeaderOrFooter -CmdLetName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
	[int]$size = ""
	[array]$vmdlist = ""
	[string]$vmhdd = ""
	if ($VM -match $CA02REGX) { $VMM = "CAIDC02" } else {
		$VMM = "CAIDC20" }
	$targetvm = Get-VM $vmname -VMMServer $vmms

	if ($targetvm -eq "") {
		Write-Log -Message "Bailed - VM Variable didn't populate`n" -errorLevel ERROR -Stack ${CmdLetName}; break 
	}

	$vmdlist = Get-SCVirtualHardDisk -VM $targetvm -VMMServer $vmms | Select-Object Name,@{ N = 'Volume Size'; E = {"{0:N2}" -f ($_.maximumsize / 1gb) } }
	if(!($vmdlist)){Write-Log -Message "Failed to gather drive listing.. Rerun this buggy old task." -errorLevel ALERT -Stack ${CmdletName} ;break}
	$vmdlist
	$vmhdd = Read-Host -Prompt "Enter Name of VHD we are expanding"
	if ($vmhdd -eq $null) { Write-Log -Message "Munbean.. Name of the disk to resize`n" -errorLevel WARNING -Stack ${CmdletName}; break }
	$vdisk = Get-SCVirtualDiskDrive -VM $targetvm -VMMServer $vmms | Where-Object { $_.VirtualHardDisk -like "$vmhdd" }

	$size = Read-Host -Prompt "Enter the new disk size eg: 250 "
	if ($size -eq $null) { Write-Log -Message "You need to enter the new disk size.." -Stack ${CmdLetName} -errorLevel ERROR; break }
	Expand-SCVirtualDiskDrive -VirtualDiskDrive $vdisk -VirtualHardDiskSizeGB $size
	Write-Log -Message "Expanded Volume" -Stack ${CmdLetName} -errorLevel SUCCESS

	Get-SCVirtualHardDisk -VMMServer $vmms -VM $targetvm | Select-Object Name,@{ N = 'Volume Name'; E = {"{0:N2}" -f ( $_.maximumsize / 1gb) } }

	Write-Color -Color Yellow -text "You should now resize the volume on the vm: $targetvm Using resize_disk -computer $targetvm -vol_Number #"
}