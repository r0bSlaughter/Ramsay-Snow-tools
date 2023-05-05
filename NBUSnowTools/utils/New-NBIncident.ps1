function New-NBIncident {
    <#
        .SYNOPSIS
        New NB Snapshot Failure Incidents assigned to yourself, with the information thats stored in $username.
           
     
        .DESCRIPTION
        Create a new ticket, assigns them to you.
        Requires on VM - for CMDB Item.
        Uses data prepopulated - hence the specific Function.
        
       
        .EXAMPLE
        New-NNBIncident -VM MTBG029
    
      
        .NOTES
            AUTHOR: Rob Slaughter ( System Administrator Ramsay Health Care )
            Email: slaughterr@ramsayhealth.com.au
            LASTEDIT: 30/05/2019 11:30pm
     
       .LINK
            
    #>
    
        param(
            [Parameter(Mandatory = $true,HelpMessage = "We need the CMDB Item")]
            [ValidateNotNullOrEmpty()]
            [string]$vm
        )
        [string]${CmdLetName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdLetName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    
        try { Get-NBCheckpoint -VM $vm }
        catch { Write-Log -Message "Oops - Failed ot get Checkpoint ID for $($vm)"  -errorLevel WARNING }
        $vmhost = (Find-VM $vm).vmhost.split('.',2)[0]
    
        New-ServiceNowIncident -Caller "$global:username" -ShortDescription "Backup Failure $vm  - 4287 " -Description "Please remove NBU Checkpoint - Using NBHYPERVTOOL.exe on host: $vmhost" -AssignmentGroup "Infrastructure Services - IT Backup" -Category "system issue" -ConfigurationItem "$VM" -CustomFields @{
            impact = '3'
            Priority = '4'
            assigned_to = "$global:username"
            comments = "$global:badchkpnt"
            location = "Head Office"
            u_service = "Backups"
            watch_list = 'Global Storage Backup Services'
            contact_type = "Event Triggered"
        } | Out-Null
    
    }
    