# Start transcript/log
Start-Transcript -path "D:\ResetWindowsProfileFolderPermissions\output.log"

# Change this to the Path of the Profile Folder
Set-Location "D:\Profiles"
$Path = "D:\Profiles"

# Get all Child folders
$Folders = Get-ChildItem -Path $Path

# for every folder 
ForEach ($Folder in $Folders){

# Split Path and get Index of .
$FolderName = (Split-Path $Folder -Leaf).ToString();
$Index = $FolderName.IndexOf('.');

# Set user and dir variable
$User = $FolderName.SubString(0,$Index);
$Dir = $Folder.Name

Write-Host "`n`n`nDoing $User"

# Get Permissions
$ACL = Get-Acl "$Path\$Dir"

# Remove Inherit from above
$acl.SetAccessRuleProtection($True, $True)

# Delete all Permissions
$ACL.Access | %{$acl.RemoveAccessRule($_)}

# Set new Permissions
$ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("$User", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")))
$ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")))
$ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("System", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")))
Set-Acl "$Path\$Dir" $Acl
Write-Host "$User done"
}

# press any key to quit
Write-Host "Press any key to continue ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Stop-Transcript
