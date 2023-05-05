function Get-remotediskpart {<#
    .SYNOPSIS
     Scan disk partions on remote host   
 
    .DESCRIPTION
    Displays disk volume inforamtion via dispart - used to identify volume numbers for resize function.   
   
    .EXAMPLE
    remote-diskpart -Computer
        
  
    .NOTES
        AUTHOR: Rob Slaughter ( System Administrator Ramsay Health Care )
        Email: slaughterr@ramsayhealth.com.au
        LASTEDIT: 06/09/2018 20:04:01
 
   .LINK
        
#>
 
Param(

    [string]$computer
    )
    Invoke-Command -ComputerName $computer -Credential $myadmin -ScriptBlock {"rescan","list disk"|diskpart}
    Invoke-Command -ComputerName $computer -Credential $myadmin -ScriptBlock {"rescan","list volume"|diskpart}

}