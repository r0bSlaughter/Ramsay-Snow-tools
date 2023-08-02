function Write-FunctionHeaderOrFooter {
    <#
        .SYNOPSIS
            Write the function header or footer to the log upon first entering or exiting a function.
        .DESCRIPTION
            Write the "Function Start" message, the bound parameters the function was invoked with, or the "Function End" message when entering or exiting a function.
            Messages are debug messages so will only be logged if LogDebugMessage option is enabled in XML config file.
        .PARAMETER CmdletName
            The name of the function this function is invoked from.
        .PARAMETER CmdletBoundParameters
            The bound parameters of the function this function is invoked from.
        .PARAMETER Header
            Write the function header.
        .PARAMETER Footer
            Write the function footer.
        .EXAMPLE
            Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
        .EXAMPLE
            Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
        .NOTES
            This is an internal script function and should typically not be called directly.
        .LINK
            https://psappdeploytoolkit.com
        #>
        [CmdletBinding()]
        param(
            [Parameter(Mandatory = $true)]
            [ValidateNotNullOrEmpty()]
            [string]$CmdletName,
            [Parameter(Mandatory = $true,ParameterSetName = 'Header')]
            [AllowEmptyCollection()]
            [hashtable]$CmdletBoundParameters,
            [Parameter(Mandatory = $true,ParameterSetName = 'Header')]
            [switch]$Header,
            [Parameter(Mandatory = $true,ParameterSetName = 'Footer')]
            [switch]$Footer
        )
    
        if ($Header) {
            Write-Log -Message 'Function Start' -Stack ${CmdletName} -errorLevel DEBUG
    
            ## Get the parameters that the calling function was invoked with
            [string]$CmdletBoundParameters = $CmdletBoundParameters | Format-Table -Property @{ Label = 'Parameter'; Expression = { "[-$($_.Key)]" } },@{ Label = 'Value'; Expression = { $_.Value }; Alignment = 'Left' } -AutoSize -Wrap | Out-String
            if ($CmdletBoundParameters) {
                Write-Log -Message "Function invoked with bound parameter(s): `n$CmdletBoundParameters" -Stack ${CmdletName} -errorLevel INFO
            }
            else {
                Write-Log -Message 'Function invoked without any bound parameters.' -Message ${CmdletName} -errorLevel ERROR
            }
        }
        elseif ($Footer) {
            Write-Log -Message 'Function End' -Stack ${CmdletName} -errorLevel SUCCESS
        }
    }