function Get-BPImageList {
    <#
        .SYNOPSIS
        Retrieves backup images from the time period speficied.   
     
        .DESCRIPTION
        List historical backup images    
       
        .EXAMPLE
        Get-BPImageList -meds vwjhc48 -client vwjhc60.east.wan.ramsayhealth.com.au -tsearch 900 (this is in hours.)
      
        .NOTES
            AUTHOR: Rob Slaughter ( System Administrator Ramsay Health Care )
            Email: slaughterr@ramsayhealth.com.au
            LASTEDIT: 30/05/2019 11:30pm
     
       .LINK
            
    #>
        param(
            [Parameter(Mandatory)]
            [ValidateNotNullOrEmpty()]
            [ValidateSet("vwhph35","vwjhc48","vwphc17","vwrch11","vwgph62")]
            [string]$meds,
            [Parameter(Mandatory,HelpMessage = "Enter the client name bonehead.")]
            [ValidateNotNullOrEmpty()]
            [string[]]$client,
            [Parameter(Mandatory,HelpMessage = "Search Period - Hours back eg. 25")]
            [ValidateNotNullOrEmpty()]
            [ValidateRange(1,1999)]
            [int32]$tsearch
        )
    
    
        Invoke-Command -ComputerName $meds -Credential $myadmin -ScriptBlock {
            & 'C:\Program Files\Veritas\Netbackup\bin\admincmd\bpimagelist.exe' -client $using:client -hoursago $using:tsearch -U | Out-String
        }
    
    }