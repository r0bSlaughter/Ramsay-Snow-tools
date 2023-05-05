function DA-Connect {
param(
[Parameter(Mandatory=$true,HelpMessage="Give me you DA bonehead - east\da-someclonw- ")]
[ValidateSet("east\da-rsl-","east\da-af-","east\da-md-","east\da-ts-")]
[string]
$DAName,
[Parameter(Mandatory=$true)]
[string]
$DC,
[Parameter(Mandatory=$true,HelpMessage="Valid Options - PS, ICM, NewPS")]
[ValidateSet("PS","ICM","NewPS")]
[string]$Action,
[Parameter(Mandatory=$true,HelpMessage="Press the YubiKey dipstick")]
[string]
$YubiKey

)
      
if (test-path C:\temp\dacred.txt ){
  $dacred = get-content "C:\temp\dacred.txt" |convertto-securestring
  #$YubiKey = Read-Host "Press the YubiKey"
  $Yda = "$DAName"+"$YubiKey"
  $myda = new-object -TypeName System.Management.Automation.PSCredential -Argument "$Yda",$dacred
  Write-Host -ForegroundColor Cyan "Credentials have been setup - Establishing connection to $($DC) `n "
   
}
  else { Write-Host -BackgroundColor RED -ForegroundColor Yellow "Huston - we have a problem, your DA creds failed to load.. `n`t Well this sucks now, doesn't it..?"}
  
  switch ($Action) {
      'PS'{ Enter-Pssession -ComputerName $DC -Credential $myda }
      'ICM' { 
        $mycmd = Read-Host -Prompt "Enter your command and syntax"
        Invoke-Command -ComputerName $DC -Credential $myda -scriptblock {$using:mycmd} }
      'NewPS' { 
          $CSV = Read-Host -Prompt "Give me csv file to import the list from"
          $Mylist = get-content $CSV
          $Global:DASession = New-PSSession -ComputerName "$Mylist" -Credential $myda
      }
      }
  }
  
