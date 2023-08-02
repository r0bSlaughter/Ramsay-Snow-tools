function Get-NBCheckpoint {
    <#
        .SYNOPSIS
        Reports the old NBU Snapshot id, if one resides. other say no image found.
     
        .DESCRIPTION
        Gets OLD NBU Snapshot ID from failed backups.    
       
        .EXAMPLE
        Get-NBCheckpoint -vm mtbg029
        Get-NBCheckpoint -vm $ticket.cmdb_ci.display_value  (This will take the name from the current open ticket).   
      
        .NOTES
            AUTHOR: Rob Slaughter ( System Administrator Ramsay Health Care )
            Email: slaughterr@ramsayhealth.com.au
            LASTEDIT: 10/05/2022 
            Update - change variable definition -VMName to lowercase. Resolved query failure with NBU not recognising switch.
     
       .LINK
            
    #>
    
        param(
            [Parameter(Mandatory = $true,HelpMessage = 'Name of VM that has backup code 4287')]
            [ValidateNotNullOrEmpty()]
            [string]$vm
        )
        [string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdLetName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    
        $vmhost = (Find-VM $vm).vmhost.split('.',2)[0]
        #foreach ($vm in $badvms) {$wrkdata = Find-VM $vm; }
        $global:badchkpnt = Invoke-Command -ComputerName $vmhost -Credential $myadmin -ScriptBlock {
            & 'C:\Program Files\Veritas\Netbackup\bin\nbhypervtool.exe' listNBUCheckpoints -vmname $using:vm
        } | Out-String | tee -Variable $worknotes
        Write-Host -ForegroundColor Gray "[VMHOST: $($vmhost)] Checkpoint details for '$($vm)' gathered successully: `n $($badchkpnt)"
        Write-Host -ForegroundColor Gray "If we reported a valid checkpoint, run the 'New-NBIncident' Function to generate a ticket."
    }
    