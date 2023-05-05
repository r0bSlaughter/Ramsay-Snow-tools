function Update-MyWork {
    <#
        .SYNOPSIS
        Update an existing ticket
    
        .DESCRIPTION
        Update an existing (ticket)
    
        .EXAMPLE
        Update-MyWork -Table incident -SysId $ticket.SysId -Values @{work_notes='value'}
    
        Updates a ticket number with a value providing no return output.
    
        .EXAMPLE
        Update-MyWork -SysId $ticket.SysId -Values @{assigned_to='$username', work_notes= "$worknotes" } -PassThru
    
        Updates a ticket number with a value, reassign's it to the specified person. return output.
    
        .NOTES
    
        #>
        [OutputType([void],[system.management.automation.pscustomobject])]
        [CmdletBinding(DefaultParameterSetName = 'Session',SupportsShouldProcess)]
        param(
            [Parameter(Mandatory,HelpMessage = "Table Name")]
            [ValidateSet("incident","sc_task","change_task","problem","sc_request","change_request")]
            [string]
            $Table,
    
            [Parameter(ParameterSetName = 'AutomationFilter')]
            [Parameter(ParameterSetName = 'Session')]
            #[Parameter(ValueFromPipelineByPropertyName)]
            [Parameter(HelpMessage = "Try using `$ticket.sys_id")]
            [Alias('sys_id')]
            [string]
            $sysid,
    
            # Hashtable of values - properties
            [Parameter(Mandatory,HelpMessage = "`$values = @{work_notes= `$worknotes}")]
            [hashtable]
            $values
        )
    
        try {
            Update-ServiceNowRecord @PSBoundParameters -Passthru
            Write-FunctionHeaderOrFooter -CmdLetName ${CmdletName} -CmdletBoundParameters $PSBoundParameters
        } catch { Write-Warning "Something Shagged..Updating $($ticket.number) with Table Type:$($Table) - Exception Thrown: $($_.Exception.Message)" }
    
    }
    