function Get-Attachment {

	# First we need to find them.. 
	# Multiple Attachments carry different sys_id's, to retrieve you need to select the correct id for the attached file.
	$tickatchlst = Get-ServiceNowAttachmentDetail -Number $ticket.number -Table incident
	Write-Host -ForegroundColor Gray "Listing attachements and ID's, correct ID is required to retrieve file."
	$tickatchlst | Format-List file_name,sys_id,sys_created_by,sys_created_on

	# To retrieve it 
	Get-ServiceNowAttachment -sysid $tickatchlst.sys_id -FileName $tickatchlst.file_name -Destination 'C:\Temp\'
	Invoke-Item C:\temp\$tickatchlst.file_name
}
