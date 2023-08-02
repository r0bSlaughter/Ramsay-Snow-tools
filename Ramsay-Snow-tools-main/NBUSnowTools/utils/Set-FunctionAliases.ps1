function Set-FunctionAliases {
	Set-Alias -Name get_NBCommands -Value Get-MyCommands -Scope Script
	Set-Alias -Name PWRESET -Value Reset-Password -Scope Script
	Set-Alias -Name qryvm -Value Get-MyVm -Scope Script
	Set-Alias -Name findvm -Value Find-VM -Scope Script
	Set-Alias -Name New-NBUSNP_Tck -Value New-NBIncident -Scope Script
	Set-Alias -Name Find-tickets -Value Get-MyWork -Scope Script
	Set-Alias -Name resolve_SNIncident -Value Resolve-Incident -Scope Script
	Set-Alias -Name update-ticket -Value Update-MyWork -Scope Script
	Set-Alias -Name List-Mytasks -Value Get-MyWork -Scope Script
	Set-Alias -Name New-bkpticket -Value New-NBKIncident -Scope Script
	Set-Alias -Name New-ticket -Value New-Incident -Scope Script

}