###################################################################
#Extend bulk VM D drive using powershell                          #
#Example: in following exampele our case Hard Disk 2 is D drive   #
#         To identify drive which need to extend use following    #
#         ***Get-Harddisk -VM <VMName>***                         #
###################################################################
#----------------- VM List path ----------------------------------#
$get_VM = import-csv -Path "C:\Temp\VMList.csv"  

#-------------------ForEach Loop ---------------------------------#  
                           
foreach( $data in $get_VM)
{
$list = $data.Name
$get_HD = Get-HardDisk -VM $list | where {$_.Name -eq 'Hard Disk 2'}    #*********************Get Drive details which need to extend****************#

if(($get_HD.Name -eq 'Hard Disk 2') -and ($get_HD.CapacityGB -eq '2'))  #*********************Validation using IF LOOP *****************************#
{

Write-Host "This is D drive of $list" -BackgroundColor DarkCyan

Get-HardDisk -VM $list | where {$_.Name -eq 'Hard Disk 2'} | Set-HardDisk -CapacityGB '20' -Confirm:$false  #****Extending Drive by 20GB************#
Write-Host "$list D drive extended to 20GB" -BackgroundColor DarkCyan
}



if (($get_HD.Name -eq 'Hard Disk 2') -and ( $get_HD.CapacityGB -gt '2')) #******************IF Loop to skip drive if already extended***************#
{
     Write-Host "$list D drive is greter than 2GB" -BackgroundColor DarkRed
     Get-HardDisk -vm $list | where {$_.Name -eq 'Hard Disk 2'} 
}
}

###------------------------Expand drive internally after adding space -----------------------------------------------------#######################

$VMList = import-csv -Path C:\temp\VMList.csv
foreach ($data in $VMList.Name)
{

$SizeDetails = Invoke-Command -ComputerName $data -ScriptBlock {(Get-PartitionSupportedSize -DriveLetter 'D').SizeMax} 
Invoke-Command -ComputerName $data -ScriptBlock {Resize-Partition -DriveLetter 'D' -Size $using:SizeDetails}

Invoke-Command -ComputerName $data -ScriptBlock {(Get-Partition -DriveLetter 'D')}

}
