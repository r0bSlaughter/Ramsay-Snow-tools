function Publish-NBCheckpointIncidents {

    <#
        .SYNOPSIS
        Register / Generate your Checkpoint error tickets 4287.
           
     
        .DESCRIPTION
        Create new Incidents for each discovered backup failure.  
       
        .EXAMPLE
        Register-NBCheckpointIncidents
      
        .NOTES
            AUTHOR: Rob Slaughter ( System Administrator Ramsay Health Care )
            Email: slaughterr@ramsayhealth.com.au
            LASTEDIT: 22/09/2021 20:30pm
     
       .LINK
            
    #>
    
        Write-Host "Creating new tickets for bad checkpoints found for each VM in `$badjobs"
        foreach ($vm in $badjobs) {
            if ($vm -ne "caidc02") {
                Write-Host "Creating new ticket to remove bad checkpoints for '$($vm)'"
                New-NBIncident -VM $vm
            } Write-Host -ForegroundColor Green "Tickets created successfully!"
        }
    }