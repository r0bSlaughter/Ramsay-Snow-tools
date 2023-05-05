<#
Event Log - Search Tool 
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true,HelpMessage="Give me a computer name dipstick.")]
    [string]
    $computername,
    [Parameter(Mandatory=$true,HelpMessage="Tab to select from the predefined options")]
    [ValidateSet('Snapshots','Iscsi','Backup','Storage','CCM','VMMSAdmin')]
    [String]
    $Action
)

Begin {
    ## Setup advanced logging features.

    [string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
            Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header 
        }
    Process {
        switch ($Action) { 
    
        'Snapshots' {

            Write-Host -ForegroundColor Magenta "Gathering Logs from $computername"
            icm $computername -Credential $myadmin -ScriptBlock { get-eventlog -LogName application -Source vss -Newest 2 |fl|out-string}
            icm $computername -Credential $myadmin -ScriptBlock {get-eventlog -LogName SYSTEM -Source volsnap -Newest 2 |fl |out-string}

            break;
        }
        'Iscsi' {
            Write-Host -ForegroundColor Cyan "Gather ISCSI Events"
            icm $computername -Credential $myadmin -ScriptBlock {get-eventlog -LogName SYSTEM -Source iScsiPrt -Newest 4 }
            break;
        }
        'Backup' {

            icm $computername -Credential $myadmin -ScriptBlock { get-vm | ft} |out-string 
            icm $computername -Credential $myadmin -ScriptBlock { vssadmin list shadows }|out-string
        }
        'Storage' {}
        'CCM' {}
        'VMMSAdmin'{
          $VMMSLog =  icm $computername -Credential $myadmin -ScriptBlock { Get-WinEvent -LogName Microsoft-Windows-Hyper-V-VMMS-Admin -MaxEvents 2 |?{$_.LevelDisplayName -notcontains "Information"}|fl Message|out-string }

          $VMMSLog
        }
        }
            }
