function resize_disk {
    <#
    .SYNOPSIS
    Remotely Extends disk partitions.    
 
    .DESCRIPTION
    Run Diskpart remotely to extend the disk partition of the volume you have previously prepared.  
    A transcript of the task is stored in C:\Temp\computername.txt
      
   
    .EXAMPLE
    resize_disk -Computer ComputerName -vol_number 3  "Being the Windows Volume number for the target volume to be extended."

    resize_disk -Computer myvm -vol_number # -Force ( This will not prompt to continue - appying the setting to the volume you specified.. be careful)
        
  
    .NOTES
        AUTHOR: Rob Slaughter
        LASTEDIT: 03/06/2022 06:03:23
 
   .LINK
        
#>

	param(
		[Parameter(Mandatory = $True)]
        [string]$computer,
		[int]$vol_Number,
        [switch]$Force
    )
    

	[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
	Write-FunctionHeaderOrFooter -CmdLetName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header

	$resizedisklog = $computer + "_" + $vol_Number + ".txt"
	$logdir = "c:\temp\"
	$outlog = $logdir + $resizedisklog

	Start-Transcript -Append -Path $outlog
    
	if (!($vol_Number)) {
		remote-diskpart $computer
		$vol_Number = Read-Host -Prompt "Enter the Number of the volume to be resized."

	}
    if($Force){
        write-log -message "-Force was present - Applying change as per your inputs." -errorLevel ALERT
	Write-Log -Message "You are incresing disk volume number $vol_number on $computer `n" -errorLevel MESSAGE -Stack ${CmdletName}
	Invoke-Command -ComputerName $computer -Credential $myadmin -ScriptBlock { "Select Volume $using:vol_Number","extend" | diskpart }
    } else { 
        Write-log -message "Force switch not used - Check and approve to complete change." -errorLevel Message -stack ${$CmdletName}
        Write-Log -Message "You are incresing disk volume number $vol_number on $computer `n" -errorLevel MESSAGE -Stack ${CmdletName}
        $Approve = Read-Host "Do you want to apply these changes. Press Yy to process - anything else to abort."
        if($Approve -like 'Y'){
	    Invoke-Command -ComputerName $computer -Credential $myadmin -ScriptBlock { "Select Volume $using:vol_Number","extend" | diskpart }}
     else { write-log -message "Aborted on request" -errorLevel ALERT ;break }}
	remote-diskpart $computer
	Stop-Transcript
}