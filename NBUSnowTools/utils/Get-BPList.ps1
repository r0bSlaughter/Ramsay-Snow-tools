function Get-BPList {
    <#
        .SYNOPSIS
        List backup contents   
     
        .DESCRIPTION
        Generates a tree view list of backed up directories and files:
        Used to search for backed up files - to be restored or just verified being backed up.
       
        .EXAMPLE
        Get-BPList -meds vwjhc48 -client vwjhc60.east.wan.ramsayhealth.com.au -sdate MM/dd/yyyy -edate MM/dd/yyyy -spath '"/D/Data"' -depth 1
        spath requires additional quotes take note of example, also Data feilds are not in quotes.
      
        .NOTES
            AUTHOR: Rob Slaughter ( System Administrator Ramsay Health Care )
            Email: slaughterr@ramsayhealth.com.au
            LASTEDIT: 02/09/2021 - 8:47 PM
     
       .LINK
            
    #>
        param(
            [Parameter(Mandatory = $true)]
            [ValidateNotNullOrEmpty()]
            [ValidateSet("vwhph35","vwjhc48","vwrch11","vwgph62")]
            [string]$meds,
    
            [Parameter(Mandatory = $true,HelpMessage = "Enter the client name bonehead.")]
            [ValidateNotNullOrEmpty()]
            [string]$client,
    
            [Parameter(Mandatory = $true,HelpMessage = "Search Periond - Start - dates US Foramt: MM/dd/yyyy '01/30/2019'")]
            [ValidateNotNullOrEmpty()]
            [string]$sdate,
    
            [Parameter(Mandatory = $true,HelpMessage = "Search Periond - End - dates US Foramt: MM/dd/yyyy '01/30/2019'")]
            [ValidateNotNullOrEmpty()]
            [string]$edate,
    
            [Parameter(Mandatory = $true,HelpMessage = "Search Path Numbski - '/D/Data/' Ring any bells?")]
            [ValidateNotNullOrEmpty()]
            [string]$spath,
    
            [Parameter(Mandatory = $false,HelpMessage = "Numberic Value - Search depth. defaults 1. maximimum 99")]
            [int16]$depth = '1'
    
        )
    
        Invoke-Command -ComputerName $meds -Credential $myadmin -ScriptBlock { & 'C:\Program Files\Veritas\Netbackup\bin\bplist.exe' -C $using:client -l -s "$using:sdate" -e "$using:edate" -R $using:depth "$using:spath" }
    }
    