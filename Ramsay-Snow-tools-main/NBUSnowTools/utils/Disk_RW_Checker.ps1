# Disk Online - RW Checker
Function Disk_RW_Checker{
param(
    [Parameter(Mandatory=$true)]
    [string]
    $computer,
    [Parameter(Mandatory=$true,HelpMessage='Admin account would be handy nobby.')]
    [pscredential] 
    $myadmin

)

icm $computer -Credential $myadmin -ScriptBlock { "list disk"|diskpart.exe}

$disk = read=host "Enter the disk to select - disk 0"

icm $computer -Credential $myadmin -ScriptBlock {"select $using:disk","online disk"|diskpart.exe}

write-host -ForegroundColor Yellow "Checking volumes disk for READ-ONLY Status - common when a disk has been offline."
icm $computer -Credential $myadmin -ScriptBlock { "select $using:disk","detail disk"|diskpart.exe}
$rodisk = read-host "If we listed a volume as read-only - then enter it here:"

if($rodisk){ icm $computer -Credential $myadmin -ScriptBlock {"select disk ","Attributes disk clear readonly"|diskpart.exe}}
}
