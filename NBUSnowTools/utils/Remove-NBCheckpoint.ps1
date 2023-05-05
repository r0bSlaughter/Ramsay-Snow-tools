Function Remove-NBCheckpoint {
    <#
        .SYNOPSIS
        Remove the old NBU Snapshot id, if one resides. other say no image found.
        Passes informatoin to script:worknotes - ready for Update-NIncident Function.   
     
        .DESCRIPTION
        Removes OLD NBU Snapshot ID from failed backups. UPdate - script:worknotes ready for Update-NIncident.    
       
        .EXAMPLE
        Remove-NBCheckpoint -vm mtbg029 -mode delete
        Remove-NBCheckpoint -vm $ticket.cmdb_ci.disply_value -mode delete   
      
        .NOTES
            AUTHOR: Rob Slaughter ( System Administrator Ramsay Health Care )
            Email: slaughterr@ramsayhealth.com.au
            LASTEDIT: 30/05/2019 11:30pm
     
       .LINK
            
    #>
    
        param(
            [Parameter(Mandatory = $true)]
            [ValidateNotNullOrEmpty()]
            [string]$VM,
    
            [Parameter(Mandatory = $true,HelpMessage = "delete or List")]
            [ValidateNotNullOrEmpty()]
            [ValidateSet("delete","List")]
            [string]$mode
        )
    
        $vmhost = (Find-VM -VM $vm).vmhost.split('.',2)[0]
        if ($mode = "delete") {
    
            if ($VM -eq $NULL) {
                $VM = Read-Host -Prompt "Enter the VM to remove the Check Points for.."
            }
    
            $worknotes = Invoke-Command $vmhost -Credential $myadmin -ScriptBlock {
                & 'C:\Program Files\Veritas\Netbackup\bin\nbhypervtool.exe' deletenbucheckpoints -vmname $using:VM
            } | Out-String
            $global:worknotes = $worknotes
            Write-Host -ForegroundColor Yellow "Currently Open ticket: $($ticket.number)"
    
            $ANS = Read-Host -Prompt "Do you want update the ticket '$($global:ticket.number)', Y or N"
    
            if ($ANS -eq 'Y') { try {
                    $Table = ($ServiceNowTable | Where-Object { $_.ClassName -match $ticket.sys_class_name })
                } catch { Write-Warning "Failed to validate Table name, because:>  $($Exception.Message)"; break }
                Write-Host -ForegroundColor Green "Updating $($ticket.number) with results from snapshot cleanup."
                try {
                    Update-MyWork -Table $Table -sysid $ticket.sys_id -Values @{ work_notes = "$worknotes" }
                } catch { Write-Warning "Updating Ticket Failed, maybe this will help: $($Exception.Message)" }
            } else {
                Write-Host -ForegroundColor Gray "results stored in worknotes." $worknotes
            }
        } elseif ($mode = "list") {
            $check = $global:bpjobs | Where-Object { $_.status -eq "4287" } | ForEach-Object { $_.client.split('.',2)[0] } | Sort-Object -Unique
            foreach ($vm in $check) {
                Invoke-Command -ComputerName ((Get-VM $vm -VMMServer caidc02).vmhost).computername -Credential $myadmin -ScriptBlock {
                    Write-Host "Checking: $using:vm"; & 'C:\Program Files\Veritas\Netbackup\Bin\nbHyperVtool.exe' listnbucheckpoints -vmname $using:vm
                }
            }
        }
    }