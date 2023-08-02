function New_SynCI {
	# - This function is called when we discover missing CI's. Details are taken from AD to validate status, name - or SCVMM if Object doesn't exist in AD.

	param($CI = $(throw "ERROR:`n`tPlease specify a valid object name.`n"))
	$ci_det = "$null"

	$serial = Read-Host 'Enter the serial number#'
	$siteLocation = Read-Host 'Enter the Site Location'
	$ip = Read-Host "Enter the IP Address  - 10.xxx.31.100"
	$model = "RS820RP+"
	$owner = "Boris Napernikov"

	$changegrp = "Infrastructure Technical Approval"


	$description = "Synology Appliance - NBU"

	$ci_det = @{
		name = $ci
		owned_by = $owner
		change_control = $changegrp
		install_status = "Installed"
		short_description = $description
		u_site_locations = "$siteLocation"
		serial_number = $serial
		model_number = $model
		ip_address = $ip

	}
	
	Write-Log -Message " CI Properties supplied. " -errorLevel MESSAGE
	$ci_det
	try { New-ServiceNowTableEntry -Table cmdb_ci_storage_server -Values "$ci_det" }
		catch { Write-Host "Oops. that sucks. $ci didn't work.." 
		}
	finally { if(!(get-ci -NAME $ci)){write-log -message "CI Creation Failed, WTF" -errorLevel ALERT} }
	
}