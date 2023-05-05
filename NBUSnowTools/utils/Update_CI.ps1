function Update_CI {
	# CI Update - Proived CI Name, and Objectes pairs.
	param(
		[Parameter(Mandatory = $true)]
		[Parameter(HelpMessage = 'CI Name - Value Pairs array.')]
		[string]
		$CIName ,
		[Parameter(Mandatory = $True,HelpMessage = "Values like @{ip_address = '123.134.212.12'} ect or in an array")]
		[array]
		$Values
	)
	[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
	Write-FunctionHeaderOrFooter -CmdLetName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header

	try {
		$sysid = (Get-ServiceNowConfigurationItem -MatchContains @{ Name = "$CIName" }).sys_id
		Update-ServiceNowRecordy -Table cmdb_ci_storage_server -sysid $sysid -Values $Values

	}
	catch { Write-Log -Message "Hmm.. that doesn't appear to have been successful. Blond Moment...?" -Stack ${CmdletName} -errorLevel WARNING
	}

	finally { Write-Log -Message "Gave up - couldn't decide on chocholate or strawberry. had both.. go figure" -errorLevel INFO

	}
}