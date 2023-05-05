function New-Incident {
    <#
        .SYNOPSIS
        Raises service now Incident.
           
     
        .DESCRIPTION
        Raises ServiceNow Incidents, assign's them back to yourself.    
        Requires 3 parameters (Short Description, Details, CMDB_Item )
        .EXAMPLE
        New-NIncident -SDSCRPT "text input string" -Details "More text" -vm cmdb_item  
      
        .NOTES
            AUTHOR: Rob Slaughter ( System Administrator Ramsay Health Care )
            Email: slaughterr@ramsayhealth.com.au
            LASTEDIT: 30/05/2019 11:30pm
     
       .LINK
            
    #>
        param(
            [Parameter(Mandatory = $true,HelpMessage = "Short Description: 'system crash - vmname'")]
            [ValidateNotNullOrEmpty()]
            [string]$SDSCRPT,
    
            [Parameter(Mandatory = $false,HelpMessage = "Additional Details if you please")]
            [ValidateNotNullOrEmpty()]
            [string]$DETAILS = "Enter something here.",
    
            [Parameter(Mandatory = $true,HelpMessage = "CMDB Item - Name of device / vm")]
            [ValidateNotNullOrEmpty()]
            [string]$VM
        )
    
        New-ServiceNowIncident -Caller "$global:username" -ShortDescription $SDSCRPT -Description $DETAILS -Category "System Issue" -AssignmentGroup "Infrastructure Services - IT Systems" -ConfigurationItem "$VM" -CustomFields @{ impact = "3"
            Priority = "4"
            u_service = "Backups"
            location = 'Head Office'
            assigned_to = "$global:username"
        }
    }