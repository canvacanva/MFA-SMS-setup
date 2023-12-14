$scriptPath = $script:MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$date = (Get-Date -f dd-MM-yyyy-hhmmss)
$inputfile = "$dir\EnableMFA.csv"
$Outfile = "$dir\UpdatedMFA.log"
$date1 = (Get-Date -f dd-MM-yyyy-hhmmss)

$Modules = get-module -Name Microsoft.Graph -ListAvailable
#Get-Module -Name Microsoft.Graph.Identity.SignIns -ListAvailable
if ($Modules.count -eq 0)
{
  Write-Host Please install Microsoft.Graph module using below command: `nInstall-Module Microsoft.Graph -ForegroundColor red
  exit
}
$Modules = get-module -Name *AzureAD* -ListAvailable
#Get-Module -Name Microsoft.Graph.Identity.SignIns -ListAvailable
if ($Modules.count -eq 0)
{
  Write-Host Please install AzureAD module using below command: `nInstall-Module AzureAD -ForegroundColor red
  exit
}

Select-MgProfile -Name Beta
connect-graph -Scopes @("UserAuthenticationMethod.Read.All";"UserAuthenticationMethod.ReadWrite.All")

Connect-AzureAD

"----------------Script started at $date1------------------" | Out-File $Outfile -Append
$data=Import-Csv -Path $inputfile
foreach ($user in $data)
{
$upn=$user.upn
$phone="+"+$user.phonenumber

 if (Get-AzureADUser -ObjectID $upn)
 {
if (!(get-MgUserAuthenticationPhoneMethod -UserId $upn).phonenumber) 
{
 #"User $upn do not have any phone number" | Out-File -FilePath $Outfile -Append

try
{
New-MgUserAuthenticationPhoneMethod -UserId $upn  -phoneType "mobile" -phoneNumber $phone
"User $upn phone number set to $phone" | Out-File -FilePath $Outfile -Append
}
catch
{
"Failed to set $upn Phone number to $phone" | Out-File -FilePath $Outfile -Append
}
}
else
{
$Already=(get-MgUserAuthenticationPhoneMethod -UserId $upn).phonenumber 
"User $upn already registered phone number to $Already " | Out-File -FilePath $Outfile -Append
}
}

else
{
"User $upn doesnt exist, please check" | Out-File -FilePath $Outfile -Append
}
}

$date2 = (Get-Date -f dd-MM-yyyy-hhmmss)

"----------------Script ended at $date2------------------" | Out-File $Outfile -Append