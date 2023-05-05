function Resolve-Incident {
    <#
        .SYNOPSIS
        Resolve your ticket with the information thats stored in $clsnotes.
           
     
        .DESCRIPTION
        Updates your ticket with the information thats stored in $clsnotes.
        you can save text to $clsnotes to pass this.
        Alternatively - use the command and pass it yourself with -clsnotes  
       
        .EXAMPLE
        Resolve-NIncident -sysid $ticket.sys_id -clsnotes  "some useful information would be handy"
      
        .NOTES
            AUTHOR: Rob Slaughter ( System Administrator Ramsay Health Care )
            Email: slaughterr@ramsayhealth.com.au
            LASTEDIT: 30/05/2019 11:30pm
     
       .LINK
            
    #>
    
        param(
            [Parameter(Mandatory = $true,HelpMessage = "Ticket sys_id")]
            [ValidateNotNullOrEmpty()]
            [string]$sysid,
    
            [Parameter(Mandatory = $true,HelpMessage = "Close Notes - Required..")]
            [ValidateNotNullOrEmpty()]
            [string]$clsnotes
        )
    
        $tnum = $global:ticket | Where-Object { $_.sys_id -eq "$sysid" } | Select-Object number
    
        $ANS = Read-Host -Prompt "Your going to resolve ticket number '$($tnum)', Press Y/N"
        if ($ANS -eq "N") {
            Write-Host -ForegroundColor Yellow "Exiting as requested."
            break
        } else {
            try {
                Update-ServiceNowIncident -sysid $sysid -Values @{ state = 'Resolved'
                    close_notes = "$clsnotes"
                    close_code = 'Service Restored ? Root Cause Was Resolved'
                    incident_state = 'Resolved' } -ErrorAction Stop | Out-Null
            } catch {
                Write-Warning "Updating ticket with sys_id '$($sysid)' and number '$($tnum)' failed with: $($_.Exception.Message)"
            }
            finally { Write-Host -ForegroundColor DarkGreen "Completed Ticket: '$($ticket.number)'" }
        }
    }