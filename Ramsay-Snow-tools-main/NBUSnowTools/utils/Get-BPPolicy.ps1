function Get-BPPolicy {
    <#
        .SYNOPSIS
        Produces a list of policies or if you provide the policy name it will provide the details of the policy.
           
     
        .DESCRIPTION
        Produces a list of policies or if you provide the policy name it will provide the details of the policy.    
        Requires 1 parameters (Media Server and Policy Name - optional. )
        .EXAMPLE
        
        Get-BPPolicy -meds vwhph35 -pol 
      
        .NOTES
            AUTHOR: Rob Slaughter ( System Administrator Ramsay Health Care )
            Email: slaughterr@ramsayhealth.com.au
            LASTEDIT: 30/05/2019 11:30pm
     
       .LINK
            
    #>
    
        param(
            [Parameter(Mandatory = $true)]
            [ValidateNotNullOrEmpty()]
            [ValidateSet("vwhph35","vwjhc48","vwphc17","vwrch11","vwgph62")]
            [string]$meds,
    
            [Parameter(Mandatory = $false)]
            [ValidateNotNullOrEmpty()]
            [string]$pol
        )
    
        if ($pol) { try {
                Write-Host -ForegroundColor Gray "Grabbing Policy Information for: $pol `n"
    
                Invoke-Command $meds -Credential $myadmin -ScriptBlock { & 'C:\Program Files\Veritas\Netbackup\bin\admincmd\bppllist.exe' $using:pol -U }
            } catch { Write-Warning "Maybe the policy name was bad: $($_.Exception.Message)" }
        } else {
            try { Invoke-Command $meds -Credential $myadmin -ScriptBlock { & 'C:\Program Files\Veritas\Netbackup\bin\admincmd\bppllist.exe' }
            } catch { Write-Warning "Hmm that's ood: $($_.Exception.Message)" }
        }
    
    
    }
    