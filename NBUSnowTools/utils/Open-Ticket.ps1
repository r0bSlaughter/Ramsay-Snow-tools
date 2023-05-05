function Open-Ticket {

	param(
		[Parameter(Position = 0)]
		[string]
		$tnum
	)

	[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
	Write-FunctionHeaderOrFooter -CmdLetName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header

	if (!$tnum) {
		$tnum = (selector_box -Myinput Multi).number }

	#$ticket = Get-ServiceNowIncident -MatchContains @{number="$tnum"}
	if ($tnum -like 'INC*') { $table = 'incident' }
	if ($tnum -like 'TASK*') { $table = 'sc_task' }
	if ($tnum -like 'CTASK*') { $table = 'change_task' }
	if ($tnum -like 'CHG*') { $table = 'change_request' }
	$ticket = (Get-MyWork -Table $table -Filter @('number','-eq',$tnum))
	$global:ticket = $ticket
	Write-Log -Message "You have Selected Ticket: $($ticket.number)`n" -errorLevel WARNING -Stack ${CmdLetName}

}