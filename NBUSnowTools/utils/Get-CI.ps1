function Get-CI {
	<#
        .SYNOPSIS
        List Configuration ITEM from CMDB   
     
        .DESCRIPTION
        ServiceNow - CMDB Query Tool
       
        .EXAMPLE
        Get-CI -Name MYPC
        Get-CI -Name -Summary -Detailed
      
        .NOTES
            AUTHOR: Rob Slaughter ( System Administrator Ramsay Health Care )
            Email: slaughterr@ramsayhealth.com.au
            LASTEDIT: 28/05/2022 - 8:47 PM
     
       .LINK
            
  #>
	param(
		[Parameter(Mandatory = $true,HelpMessage = "Enter the CI name")]
		[string]
		$NAME,
          [Parameter(Mandatory=$false,HelpMessage = "Short Summary")]
          [switch]
          $summary,
          [parameter(Mandatory=$false,HelpMessage = "Detailed")]
          [switch]
          $detailed
	)

     if($summary){ 
          Write-Host -ForegroundColor Yellow "Gathering Summary info..."
    

     try { 
          
	Get-ServiceNowConfigurationItem -MatchContains @{ Name = "$name" }|ft name, model_number, ip_address, serial_number, u_site_locations, install_status
     } catch { Write-Host -ForegroundColor Cyan "Something shagged it.. best be checking the error log."}
     finally { write-host "Done.."}

     }

     if($detailed){
          Write-Host -ForegroundColor green "Detailed View selected."
          Get-ServiceNowConfigurationItem -MatchContains @{ Name = "$name" }|fl
          break;

          

}

if(!($detailed),(!($summary)))
{
Write-Host -ForegroundColor Green "Gather basic information.. "
Get-ServiceNowConfigurationItem -MatchContains @{Name="$name"}

}
}
<#name = $ci
		owned_by = $owner
		change_control = $changegrp
		install_status = "Installed"
		short_description = $description
		u_site_locations = "$siteLocation"
		serial_number = $serial
		model_number = $model
		ip_address = $ip
#>