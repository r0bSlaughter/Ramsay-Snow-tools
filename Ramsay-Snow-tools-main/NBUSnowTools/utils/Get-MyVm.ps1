function Get-MyVm {

    <#
        .SYNOPSIS
        Qery VM the virtual machine and host.
           
     
        .DESCRIPTION
        Returns, Name, status, location and host it resides on, used to provide information to other Functions.
        Get-VM is just a quick bang in.. crappy but used in a pipe foreach ( vm in myvar ) {Get-VM $vm}
        .EXAMPLE
        
    
        Get-VM $vm 
        Name      Status Location                                        HostName
        ----      ------ --------                                        --------
        VWIDC587 Running C:\ClusterStorage\ndidc001_chidc007_17\VWIDC587 shidc099.east.wan.ramsayhealth.com.au
      
        .NOTES
            AUTHOR: Rob Slaughter ( System Administrator Ramsay Health Care )
            Email: slaughterr@ramsayhealth.com.au
            LASTEDIT: 30/05/2019 11:30pm
     
       .LINK
            
    #>
    
        param(
            [Parameter(Mandatory = $true)]
            [ValidateNotNullOrEmpty()]
            #[Parameter(ValueFromPipeline)]
            [string]$vm
        )
        if ($VM -eq $NULL) { $VM = Read-Host -Prompt "Enter the name of the VM to find.." }
        if ($VM -match $CA02REGX) { $VMM = "CAIDC02" } else {
            $VMM = "CAIDC20" }
    
        return Get-SCVirtualMachine -Name $vm -VMMServer $VMM | Select-Object ComputerNameString,StatusString,Location,Hostname
    }
    