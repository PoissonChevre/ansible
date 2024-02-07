<#
.DESCRIPTION
    PowerShell script to create/check the directories of the users at logon.
    SCRIPT FORMATTING FOR MORE READABILITY: Header comment block, Variables names, Block Try-Catch, PascalCase, Comments

.PARAMETER BasePath
    The path where to create the directories.

.PARAMETER ExcludedAccounts
    The accounts to exclude.

.EXAMPLE
    Open a PowerShell window, to run the script you have to configure your execution policy to Bypass:
    > Set-ExecutionPolicy Bypass -Scope Process -Force
    Fill the variables $BasePath and $ExcludedAccounts with your values and run the script:
    > .\CreateUserPrivateDirectory.ps1

.NOTES
    AUTHOR: Renaud Charlier
    DATE: 01-02-2024
    VERSION: 1.0
#>

# Import the Active Directory module
Import-Module ActiveDirectory

# Define script parameters
$ExcludedAccounts = @("Administrator", "u.ansible", "sshd", "Guest")
$BasePath = "\\SRV-INF-001\BARZINI_SHARE\USERS_SHARE"

# Get enabled users without a home directory, excluding specified accounts
$Users = Get-ADUser -Filter 'Enabled -eq $true' -Properties HomeDirectory |
         Where-Object { $_.HomeDirectory -eq $null -and $_.SamAccountName -notin $ExcludedAccounts }

# Iterate through each user
foreach ($User in $Users) {

    # Construct the path for the user folder
    $UserFolder = Join-Path -Path $BasePath -ChildPath $User.SamAccountName

    # Check if the user folder doesn't already exist
    if (-not (Test-Path -Path $UserFolder)) {

        # Create the user folder
        New-Item -Path $UserFolder -ItemType Directory

        # Get the ACL of the user folder
        $Acl = Get-Acl $UserFolder

        # Remove existing access rules
        $Acl.Access | ForEach-Object {
            $Acl.RemoveAccessRule($_)
        }

        # Disable inheritance on the folder
        $Acl.SetAccessRuleProtection($true, $false)

        # Resolve the user identity
        $ResolvedUser = $User.SamAccountName

        # Create an access rule for the user with Modify permissions
        $UserRule = New-Object System.Security.AccessControl.FileSystemAccessRule($ResolvedUser, "Modify", "None", "None", "Allow")

        # Set the access rule on the ACL
        $Acl.SetAccessRule($UserRule)

        # Resolve the group identity
        $ResolvedGroup = "Administrators"

        # Create an access rule for the group BARZINI/Administrators with Modify permissions
        $GroupRule = New-Object System.Security.AccessControl.FileSystemAccessRule($ResolvedGroup, "Modify", "None", "None", "Allow")

        # Set the access rule on the ACL
        $Acl.SetAccessRule($GroupRule)

        # Apply the modified ACL to the user folder
        Set-Acl -Path $UserFolder -AclObject $Acl
    }
}
