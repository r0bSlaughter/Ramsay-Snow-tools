function Connect-Now {
	param(
		[Parameter(Mandatory = $true)]
		[ValidateSet("ramsayhealth.service-now.com","ramsayhealthdev.service-now.com")]
		[string]$snow = " ",

		[Parameter(Mandatory = $true,HelpMessage = "PSCredential object for SNow user account",ValueFromPipeline = $true)]
		[pscredential]$sncred
	)

	New-ServiceNowSession -Url $snow -Credentials $sncred
	#Set-ServiceNowAuth -Url $snow -Credentials $sncred 'depreciated with servicenow - 2.2.0'

	#$global:username = (Get-ServiceNowUser -MatchContains @{email="$env:username"}).name
	$global:username = (Get-ServiceNowRecord -Table sys_user -Filter @('user_name','-like',"$env:username")).Name
	Write-Log -Message "SNOW Connection Initialisation" -errorLevel DEBUG
	Write-Host -ForegroundColor Cyan "`tWelcome: $global:username `n `tTo Robs - Toolbag."
}