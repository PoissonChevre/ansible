<#
.NAME
    MountNetworkDrive.ps1

.DESCRIPTION
	PowerShell script to mount a network drive with variables for drive letter and network path.
    It allows flexibility by defining variables for the drive letter and network path.
    The drive mapping is made persistent across reboots.

.USE
    Open a Powershell window, to run the script you have to configure your execution policy to Bypass:
    > Set-ExecutionPolicy Bypass -Scope Process -Force
	Fill the variables $DriveLetter and $NetworkPath with your values and run the script:
	> ./MountNetworkDrive.ps1

.SCRIPT FORMATTING FOR MORE READIBILITY
    Header comment block , Variables names, PascalCase, Comments

.AUTHOR
    Renaud Charlier

.DATE
    28-01-2024

.VERSION
    1.0
#>

# Define the drive letter and network path in variables
$DriveLetter = "P"
$NetworkPath = "\\SRV-INF-001\BARZINI_SHARE"

# This method uses New-PSDrive cmdlet to map a network drive
# $DriveLetter: Specifies the drive letter from the variable
# $NetworkPath: Specifies the UNC path to the network share from the variable
# -PSProvider: Specifies the provider, FileSystem for network drives
# -Scope Global Mount for All users on the local machine
# -Persist: Makes the drive mapping persistent across reboots

# New-PSDrive -Name $DriveLetter -Root $NetworkPath -PSProvider FileSystem -Scope Global -Persist
New-PSDrive -Name $DriveLetter -Root $NetworkPath -PSProvider FileSystem -Scope Global -Persist
Write-Host  "`n Network drive $DriveLetter : mapped to $NetworkPath using New-PSDrive." -ForegroundColor DarkGreen

# Displays the mounted disk
# Get-PSDrive $DriveLetter

# Unmount the drive
# Remove-PSDrive $DriveLetter
