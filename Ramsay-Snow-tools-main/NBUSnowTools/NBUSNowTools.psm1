
<#PSScriptInfo

.VERSION 5.1.0.0

.GUID 545df256-615b-4e1d-bf6b-60ea12c07420

.AUTHOR Rob Slaughter

.COMPANYNAME Ramsay Health Care

.COPYRIGHT Rob Slaughter 2019 - 2023.(c)

.TAGS 
   ServiceNow, Netbackup PS Tools

.LICENSEURI 

.PROJECTURI 

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 
servernow
virtualmachinemanager

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES
   
   4.8.3 - Restructured functions, aliases 
   4.8.4.1 - Resovle typo's in funciton
   4.8.4.2 - Resolve type in removecheckpoint funciton
   4.8.4.3 - Renamed Create-NBCheckpointsIncidents to Register-NBCheckpointIncidents
   4.9.0.0 - Changed SNOW Functions - to align with ServiceNow 3.0
   4.9.0.2 - Bug fixes - qry_vm
   4.9.1.0 - Bug fixes and minor updates - get-bppol - added Policy Detail Listing, Open-Tickets (ticketnumber), Get-MyWork task listing not showing closed.
   4.9.1.1 - Added Change Tasks 
   5.0.0.1 - Added Formated debuging - Log tracking, CMDB Functions
   5.1.0.5 - Minor updates - Regex ect.
#>


#----------------------------------------------------------[Declarations]----------------------------------------------------------#


## Define script scoped variables
$global:username = ""
$global:bpjobs = "$null"
$global:badchkpnt = ""
$global:delchkpnt = ""
$global:worknotes = ""
$global:badjobs = ""
$global:tickets = ""
$global:medsrvs = "$null"

## Define local scoped variables
$domain = "EAST\"
$standardUser = "$env:username"
$searchaduser = (Get-ADUser $standardUser).surname
$adminUser = $domain += ((Get-ADUser -SearchBase 'OU=Infrastructure,OU=Accounts,OU=Tier 1,OU=Admin,DC=east,DC=wan,DC=ramsayhealth,DC=com,DC=au' -Properties Description -Filter *) | Where-Object { $_.Description -like "*$searchaduser*" }).Name
$credPath = "C:\temp"

$global:CA02REGX = 'VWIDC\w|MT\w|NTN\w|VAIDC\w|VWLMP\w'

#----------------------------------------------------------[Main Program Functions]----------------------------------------------------------#




function ConvertFrom-UnixDate {
<#
     .SYNOPSIS
         Convert from Unix time to DateTime

     .DESCRIPTION
         Convert from Unix time to DateTime

     .PARAMETER Date
         Date to convert, in Unix / Epoch format

     .PARAMETER Utc
         Default behavior is to convert Date to universal time.

         Set this to false to return local time.

     .EXAMPLE
         ConvertFrom-UnixDate -Date 1441471257

     .FunctionALITY
         General Command
     #>
	param(
		[int]$Date,
		[bool]$Utc = $true
	)

	# Adapted from http://stackoverflow.com/questions/10781697/convert-unix-time-with-powershell
	$unixEpochStart = New-Object DateTime 1970,1,1,0,0,0,([DateTimeKind]::Utc)
	$Output = $unixEpochStart.AddSeconds($Date)

	if (-not $utc)
	{
		$Output = $Output.ToLocalTime()
	}

	return $Output
}
function Reset-Password {
	param(
		[Parameter(Mandatory = $true,HelpMessage = "Please Enter and Account type - pleb, admin, da",Position = 1)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet("da","admin","pleb")]
		[string]$AccType
	)

	switch ($AccType) {
		"da" {
			Write-Host -BackgroundColor Magenta "Changing DA Perms.."
			Read-Host -Prompt "Enter your new DA Password and press enter:" -AsSecureString | ConvertFrom-SecureString | Out-File C:\temp\dacred.txt
		}
		"admin" {
			Write-Host -ForegroundColor Yellow "Lets change the admin account..`n"
			Read-Host -Prompt "Enter your ADMIN Password and press enter:" -AsSecureString | ConvertFrom-SecureString | Out-File C:\temp\mycred.txt
		}
		"pleb" {
			Write-Host -ForegroundColor Gray "Setting up base pleb - eg east\mungbean `n"
			Read-Host -Prompt "Waiting Mungbean - PW please.." -AsSecureString | ConvertFrom-SecureString | Out-File C:\temp\mypleb.txt
		}
	}
}

function Get-MyCommands {

	Write-Host -ForegroundColor Gray "`n`tRun Get-BPJobs, to generate a working list of backup history and show the faults."
	Write-Host -ForegroundColor gray "`n`tTicket Management - Run Find_tickets to generate a list of tickets assigned to yourself, then use Open-Ticket to open the ticket selector."
	Write-Host -ForegroundColor gray "`n`tUpdate-Ticket will update notes in the ticket with what ever is stored in worknotes. Store comments in this variable to be added to the job notes."
	Write-Host -ForegroundColor Gray "`tRun Publish-NBCheckpointIncidents - to auto generate tickets for any 4287 errors."
	Write-Host -ForegroundColor Gray "`tRun Remove-NBCheckpoint - to remove checkpoints. `n`n"
}


function Install-Dependencies {
	param([Parameter(Mandatory = $true)]
		$module
	)

	if ((Get-PSRepository).Name -match 'OnPremPSRepo') { $repo = 'OnPremPSRepo'; Write-Host -ForegroundColor Yellow "Found local OnPremPSRepo - Seaching Local" } else { $repo = 'PSGallery' }
	Write-Warning "Installing required dependencies from PowerShell Repository for this tool if necessary, please wait."

	Install-Module -Name "$($module)" -Repository "$($repo)" -Force -AllowClobber -SkipPublisherCheck -AcceptLicense

}


function global:set-ConsolePosition ([int]$x,[int]$y) {
	# Get current cursor position and store away 
	$position = $host.ui.rawui.cursorposition
	# Store new X and Y Co-ordinates away 
	$position.x = $x
	$position.y = $y
	# Place modified location back to $HOST 
	$host.ui.rawui.cursorposition = $position
}

function global:draw-line ([int]$x,[int]$y,[int]$length,[int]$vertical) {
	# Move to assigned X/Y position in Console  
	set-ConsolePosition $x $y
	# Draw the Beginning of the line 
	Write-Host "*" -NoNewline -ForegroundColor Yellow
	# Is this vertically drawn?  Set direction variables and appropriate character to draw  
	if ([boolean]$vertical)
	{ $linechar = "!"; $vert = 1; $horz = 0 }
	else
	{ $linechar = "-"; $vert = 0; $horz = 1 }
	# Draw the length of the line, moving in the appropriate direction  
	foreach ($count in 1..($length - 1)) {
		set-ConsolePosition (($horz * $count) + $x) (($vert * $count) + $y)
		Write-Host $linechar -NoNewline -ForegroundColor Yellow
	}
	# Bump up the counter and draw the end 
	$count++
	set-ConsolePosition (($horz * $count) + $x) (($vert * $count) + $y)
	Write-Host "*" -NoNewline -ForegroundColor Yellow
}

function global:draw-box ([int]$width,[int]$length,[int]$x,[int]$y) {
	# Do the four sides  
	foreach ($box in 0..3) {
		# Variable to flip whether we?re on the left / top of the box or not 
		$side = $box % 2
		# Variable to switch whether it?s a vertical or horizontal line 
		$vert = [int](($box - .5) / 2)
		# compute the Width and Length so we can ?switch them? 
		$totalside = $width + $length
		# Length of line will be dependant on the Direction 
		# (vertical or Horizontal) 
		$linelength = ($vert * $length) + ([int](!$vert) * $width)
		$result = $totalside - $linelength
		# flip in the correct X Y coordinates for the maximum  
		$ypass = ([int](!$vert) * $side * $result) + $y
		$xpass = ($vert * $side * $result) + $x
		# Draw the line  
		draw-line $xpass $ypass $linelength $vert
	}
}
#----------------------------------------------------------[Environment Setup]----------------------------------------------------------#
function set-myconsole {
	#First lets clean the slate.
	Clear-Host

	$Shell = $Host.ui.rawui
	$Shell.WindowTitle = "<<<--- Netbackup - ServiceNow Toolkit --->>>"
	#$Shell.BackgroundImage = "C:\temp\RHCWallpaper.jpg"
	$bsize = $Shell.BufferSize
	$bsize.Width = "260"
	$bsize.Height = "3000"
	$Shell.BufferSize = $bsize
	$size = $Shell.WindowSize
	$size.Width = "240"
	$size.Height = "70"
	$Shell.WindowSize = $size
	[Console]::ResetColor()
}
Set-Alias rver Resolve-Error

## Update TLS Security to version 1.2 - Post security tighting on ServiceNow web portal. 
## TLS 1.3 - Not support below Server 2022, (Windows 11)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Intialise Terminal Screen paraameters.
set-myconsole


## Import required modules
$RequiredModules = @("Write-Log")
foreach ($module in $RequiredModules) {

	Import-Module -Name $module
	#check it's in.
	if (!(Get-Module $module)) { Write-Log -Message "Failed to import $($module)" -Stack ${CmdletName} -errorLevel WARNING
		Install-Dependencies
	} else { Write-Log -Message "$($module) has been imported ready." -errorLevel MESSAGE }
}
Write-Verbose 'Import everything in sub folders folder'
foreach ($Folder in @('Utils', 'Public')) {
    $Root = Join-Path -Path $PSScriptRoot -ChildPath $Folder
    if (Test-Path -Path $Root) {
        Write-Verbose "processing folder $Root"
        $Files = Get-ChildItem -Path $Root -Filter *.ps1 -Recurse

        # dot source each file
        $Files | Where-Object { $_.name -NotLike '*.Tests.ps1' } |
        ForEach-Object { Write-Verbose $_.basename; . $PSItem.FullName }
    }
}

Export-ModuleMember -Function (Get-ChildItem -Path "$PSScriptRoot\utils\*.ps1").BaseName
## Configure credential sets for standard user, admin user, and SNow user

Write-Log -Message "Setting up Admin credentials" -errorLevel DEBUG

if (Test-Path "$($credpath)\mycred.txt") {
	$mycred = Get-Content "$($credpath)\mycred.txt" | ConvertTo-SecureString
	$Global:myadmin = New-Object -TypeName System.Management.Automation.PSCredential -argument "$($adminUser)",$mycred
	Write-Host -ForegroundColor Gray "MyAdmin for generic systems admin authentication.`n" }
else {
	Write-Log -Message "WTF - Get Some Meds, this is going to be painful.`n" -errorLevel ERROR -Stack ${CmdLetName}
	Reset-Password -acctype "admin"
}
#$aliases.GetEnumerator() | ForEach-Object {
 #   Set-Alias -Name $_.Key -Value $_.Value
#}


Write-Log -Message "Setting up credentials for '$($standardUser)'`n" -errorLevel DEBUG

if (Test-Path "$($credpath)\mypleb.txt") {
	$mypbcred = Get-Content "$($credpath)\rspleb.txt" | ConvertTo-SecureString
	$global:sncred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "$($standardUser)",$mypbcred
	Write-Log -Message "-- Pleboid ServiceNow - sncred --" -errorLevel SUCCESS }
else {
	Write-Log -Message "Holy shit BATMAN, some CrackHead-JOKER has trashed the file - Running PW Setup`n" -errorLevel ALERT -Stack ${CmdLetName}
	Reset-Password -acctype "pleb"
}


Write-Host -ForegroundColor Yellow "Initiating ServiceNow connection for --> '$($standardUser)'`n"
try {
			New-ServiceNowSession -url ramsayhealth.service-now.com -Credential $sncred | Out-Null
			$global:username = (Get-ServiceNowRecord -Table sys_user -Filter @('user_name','-like',"$env:username")).Name
	} catch {
	Write-Log -Message "Connection to SNow failed with error: $($_.Exception.Message) `n" -errorLevel ERROR -stack ${$CmdletName}
}



## Gathering list of media servers to populate valiation sets.
$nbmedlist = Invoke-Command vwjhc48 -Credential $myadmin -ScriptBlock { nbemmcmd.exe -list_sts_media_servers -masterserver vwbkp001 -listhosts -brief }
$mdsrvs = $nbmedlist | ForEach-Object { $_.split('.',2)[0] } | sort -Unique
foreach ($line in $mdsrvs) { $global:medsrvs += "`"$($line)`"," }
#$global:medsrvs = foreach ($line in $mdsrvs){write-host "`"$($line)`"," -nonewline}

## Listing help for this module
Get-MyCommands
global:draw-box -length 12 -Width 160 -x 1 -y 15
## Generate Function aliases for backwards compatibility
Set-FunctionAliases

Export-ModuleMember -Alias *

