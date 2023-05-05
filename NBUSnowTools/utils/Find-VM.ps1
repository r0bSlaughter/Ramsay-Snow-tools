function Find-VM {

    <#
        .SYNOPSIS
        Find the virtual machine and host.
           
     
        .DESCRIPTION
        Finds your VM and Host it resides on, used to provide information to other Functions.
       
        .EXAMPLE
        Find-VM -vm VWIDC672
        Name       VMHost
        -----     --------
        VWIDC672  SHIDC123
      
        .NOTES
            AUTHOR: Rob Slaughter ( System Administrator Ramsay Health Care )
            Email: slaughterr@ramsayhealth.com.au
            Removed Module check - module is loaded by default.it's just wasted overhead.
            LASTEDIT: 10/11/2022 7:30pm
     
       .LINK
            
    #>
        param([Parameter(Position = 0)]
            #[Paremter(ValueFromPipeline)]
            [string]$VM,
            # Parameter help description
            [Parameter(Position = 1)] [string]
            $VMM = "caidc02"
        )
        [string]${CmdLetName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdLetName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
        $vmname = $null
        $vmhost = $null
    
        if ($VM -eq $NULL) { $VM = Read-Host -Prompt "Enter the name of the VM to find.." }
        if ($VM -match $CA02REGX) { $VMM = "CAIDC02" } else {
            $VMM = "CAIDC20" }
        Get-SCVirtualMachine $VM -VMMServer $vmm | Select-Object @{ N = 'vmname'; E = { $_.Name } },@{N='Description';E={$_.Description}},@{ N = 'vmhost'; E = { $_.HostName } },@{ N = 'status'; E = { $_.status } },@{ N = 'VMTools Version'; E = { $_.VMAddition } },@{N='Tag'; E={$_.Tag}},@{N="Assign Mem KB";E={$_.Memory}},@{N='CPU Count';E={$_.CpuCount}}
    
    }