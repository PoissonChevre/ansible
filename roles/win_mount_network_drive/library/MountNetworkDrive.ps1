<#
.DESCRIPTION
	PowerShell script to mount a network drive with variables for drive letter and network path.
    It allows flexibility by defining variables for the drive letter and network path.
    The drive mapping is made persistent across reboots.
    SCRIPT FORMATTING FOR MORE READIBILITY : Header comment block , Variables names, Block Try-Catch, PascalCase, Comments

.PARAMETER DriveLetter
    The drive letter to assign to the network path.

.PARAMETER NetworkPath
    The UNC path to the network share.

.EXAMPLE
    Open a Powershell window, to run the script you have to configure your execution policy to Bypass:
    > Set-ExecutionPolicy Bypass -Scope Process -Force
	Fill the variables $DriveLetter and $NetworkPath with your values and run the script:
	> .\MountNetworkDrive.ps1

.NOTES
    AUTHOR: Renaud Charlier
    DATE: 05-02-2024
    VERSION: 1.3
#>

# Pass the drive letter and the UNC network path in parameters
param(
    [string]$DriveLetter = "S",
    [string]$NetworkPath = "\\SRV-INF-001\BARZINI_SHARE"
)

# https://learn.microsoft.com/fr-fr/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-7.4
# Errors are treated as terminating, causing the script to stop executing immediately. An error message is displayed.
$ErrorActionPreference = 'Stop'

# This method uses New-PSDrive cmdlet to map a network drive
# $DriveLetter: Specifies the drive letter (variable)
# $NetworkPath: Specifies the UNC path to the network share (variable)
# -PSProvider: Specifies the provider, FileSystem for network drives
# -Persist: Makes the drive mapping persistent 

try {
    # Check if the drive letter is already in use + WARNING output 
    if ((Get-PSDrive -Name $DriveLetter -ErrorAction SilentlyContinue)) 
        {
        Write-Warning "Drive letter $DriveLetter is already in use." 
        } 
    else 
        {
        # Attempt to map the network drive + output
        New-PSDrive -Name $DriveLetter -Root $NetworkPath -PSProvider FileSystem -Persist
        Write-Output "Network drive $DriveLetter : mapped to $NetworkPath."
        }
    }
catch 
        {
         # ERROR output the error(s)
        Write-Error "ERROR: Failed to map network drive $DriveLetter to $NetworkPath : $_"
        }
finally 
        {
        # $ErrorActionPreference = Restore the initial value: errors are suppressed, but the script continues to run
        $ErrorActionPreference = 'Continue'
         }


# Displays the mounted disk
# Get-PSDrive $DriveLetter

# Unmount the drive
# Remove-PSDrive $DriveLetter
