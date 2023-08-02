
function Get-BPJobs {
<#
    .SYNOPSIS
    List backups jobs that have run during the period entered.   
 
    .DESCRIPTION
    Generates an array of backup jobs and details, used to pass information to ticketing system.
    Also generated a list of VMs with bad jobs - e.g. error 4287
   
    .EXAMPLE
    Get-BPJobs -user $myadmin -meds vwhph35 -tsearch 12   
  
    .NOTES
        AUTHOR: Rob Slaughter ( System Administrator Ramsay Health Care )
        Email: slaughterr@ramsayhealth.com.au
        LASTEDIT: 30/05/2019 - 11:29pm
 
   .LINK
        
#>
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param(
		[Parameter(HelpMessage = "Your admin called - myadmin ")]
		#[ValidateNotNullOrEmpty()]
		[pscredential]$user = "$myadmin",

		[Parameter(Mandatory = $true,HelpMessage = "Just pick one numbski")]
		[ValidateNotNullOrEmpty()]
		[ValidateSet("vwjhc48","vwrhc22","vwgph63")]
		[string]$meds,

		[Parameter(Mandatory = $true,HelpMessage = "Enter number of hours back to start our search from:eg 12 ")]
		[ValidateNotNullOrEmpty()]
		[ValidateRange(0,48)]
		[int]$tsearch
	)

	$global:bpjobs = $bpjobs
	$datetime = ((Get-Date).AddHours(- $tsearch))
	$tstamp = $datetime -f "mm/dd/yyyy hh:mm:ss"
	$bpjobs = Invoke-Command -ComputerName $meds -Credential $user -ScriptBlock { bpdbjobs.exe -all_columns -t $using:tstamp | ConvertFrom-Csv -Delimiter "," -Header jobid,jobtype,state,status,policy,schedule,client,server,started,elapsed,ended,stunit,try,operation,kbytes,files,pathlastwritten,percent,jobpid,owner,subtype,classtype,schedule_type,priority,Group-Object,masterserver,retentionunits,retentionperiod,compression,kbyteslastwritten,fileslastwritten,filelistcount,[files],trycount,[trypid,trystunit,tryserver,trystarted,tryelapsed,tryended,trystatus,trystatusdescription,trystatuscount,[trystatuslines],trybyteswritten,tryfileswritten],parentjob,kbpersec,Copy-Item,robot,vault,profile,session,ejecttapes,srcstunit,srcserver,srcmedia,dstmedia,stream,suspendable,resumable,restartable,datamovement,snapshot,backupid,killable,controllinghost
	}
	$global:bpjobs = $bpjobs
	Write-Host -ForegroundColor Yellow " Listing - 4287 - snapshot errors `n"
	$global:badjobs = $bpjobs | Where-Object { $_.status -eq '4287' -and $_.client -notlike 'caidc*' } | ForEach-Object { $_.client.split('.',2)[0] } | sort -Unique
	if ($global:badjobs) {
		foreach ($vm in $badjobs) { qryvm -VM $vm }
	}

	$global:badjobs2 = $bpjobs | Where-Object { $_.status -eq '50' -and $_.client -notlike 'caidc*' } | ForEach-Object { $_.client.split('.',2)[0] } | sort -Unique
	if ($global:badjobs2) { Write-Host -ForegroundColor Yellow " `n`t Listing Status 50's Failed to Write..`n"
		$global:badjobs2
		foreach ($vm in $global:badjobs2) { qryvm -VM $vm } }

	$global:badjobs3 = $bpjobs | Where-Object { $_.status -eq '48' -and $_.client -notlike 'caidc*' } | ForEach-Object { $_.client.split('.',2)[0] } | sort -Unique
	if ($global:badjobs3) { Write-Host -ForegroundColor Yellow "`n`t Listing Status 48 - VM not found `n"
		$global:badjobs3
		foreach ($vm in $global:badjobs3) { qryvm -VM $vm } }

	$global:badjobs4 = $bpjobs | Where-Object { $_.status -eq '156' -and $_.client -notlike 'caidc*' } | ForEach-Object { $_.client.split('.',2)[0] } | sort -Unique
	if ($badjobs4) { Write-Host -ForegroundColor Yellow "`n`t Listing 156 Snapshot Errors `n"
		foreach ($vm in $badjobs4) { qryvm -VM $vm

		} }
}