<#
.SYNOPSIS
    This script facilitates the installation and registration of the PnP PowerShell module.
.DESCRIPTION
    The script is divided into two main sections, each responsible for different aspects of working with the PnP PowerShell module:
    
    1. Installation: Installs the PnP.PowerShell module if not already installed.
    2. Registration: Registers the PnP Management Shell Access.

.NOTES
    After running Register-PnPManagementShellAccess login with your account and press accept.
#>

# SECTION: Installation
<#
.DESCRIPTION
    This section is responsible for installing the PnP.PowerShell module if it is not already installed on the system.
#>

# Check if the PnP.PowerShell module is installed.
if (-not (Get-Module -ListAvailable -Name PnP.PowerShell)) {
    # Install the PnP.PowerShell module.
    Install-Module -Name PnP.PowerShell -Scope CurrentUser -Force -AllowClobber
    Write-Host "PnP.PowerShell has been installed." -ForegroundColor Green
} else {
    Write-Host "PnP.PowerShell is already installed." -ForegroundColor Yellow
}

# SECTION: Registration
<#
.DESCRIPTION
    This section is responsible for registering PnP Management Shell Access.
#>

# Register PnP Management Shell Access.
Register-PnPManagementShellAccess