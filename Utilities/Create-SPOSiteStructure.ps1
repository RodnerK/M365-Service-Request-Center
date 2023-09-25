<#
.SYNOPSIS
This script creates a SharePoint Online site structure by applying a PnP template and adding list items from specified CSV files.

.DESCRIPTION
The Create-SPOSiteStructure function in this script connects to a target SharePoint Online site using the provided credentials, applies the specified PnP site template, and then populates the SharePoint lists with the items from corresponding CSV files located in the Config folder.
Each CSV file corresponds to a different list, and the names of the CSV files are assumed to match the names of the lists.

.PARAMETER Account
(Optional) The account used to connect to SharePoint Online. If not provided, a credential prompt will appear.

.PARAMETER Password
(Optional) The password used to connect to SharePoint Online. If not provided, a credential prompt will appear.

.PARAMETER TargetSiteUrl
(Mandatory) The URL of the target SharePoint Online site.

.EXAMPLE
.\Create-SPOSiteStructure.ps1 -TargetSiteUrl "https://example.sharepoint.com/sites/target" -Account "user@example.com" -Password "Password1234"

.NOTES
File Name: Create-SPOSiteStructure.ps1
Prerequisites: PnP.PowerShell module should be installed.
#>

[CmdletBinding()]
PARAM (
    [Parameter(Mandatory = $false)]
    [string]$Account = [System.String]::Empty,
    [Parameter(Mandatory = $false)]
    [string]$Password = [System.String]::Empty,
    [Parameter(Mandatory = $true)]
    [string]$TargetSiteUrl = [System.String]::Empty
)
# Initializing the script environment and importing required modules
BEGIN {
    #Region: Variables
    Set-Location $PSScriptRoot
    $oldEAP = $ErrorActionPreference
    $ErrorActionPreference = "Stop"
    $scriptPath = (Get-Item $PSScriptRoot).Parent.FullName
    $configPath = Join-Path $scriptPath "Config"
    $Culture = (Get-Culture).DateTimeFormat 
    $DateTimeShortFormat = $Culture.ShortDatePattern + " " + $Culture.ShortTimePattern
    $date = (Get-Date).ToString($DateTimeShortFormat) -replace ("/", ".") -replace (":", ".")
    #endregion

    #Region: Modules and Assemblies
    try {
        if (!(Get-Module -Name PnP.PowerShell)) { Import-Module -Name PnP.PowerShell -NoClobber }
    }
    catch {
        throw "Failed to load PnP.PowerShell module. Please ensure it's installed."
    }
    #endregion

    #Region: Functions
        
    # Function to get credentials for connecting to SharePoint Online
    function GetCredentials {
        param (
            [Parameter(Mandatory = $false)]
            [string]$Account,
            [Parameter(Mandatory = $false)]
            [string]$Password
        )
        process {
            if (![string]::IsNullOrEmpty(($Account)) -or ![string]::IsNullOrEmpty(($Password))) {
                $Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Account, ($Password | ConvertTo-SecureString -AsPlainText -Force)
            }
            else {
                Write-Host "Account or Password is empty" -ForegroundColor Red
                $Credentials = Get-Credential -Message "Enter credentials for SharePoint Online"
            }
            if ($null -eq $Credentials) {
                throw "Credentials are empty"
            }
            return $Credentials
        }
    }

    # Function to apply PnP Template to the site
    function Update-PNPtemplate {
        param (
            [Parameter(Mandatory = $true)]
            [string]$SiteTemplate
        )
        process {
            try {
                Write-Host "Applying Site Template: $SiteTemplate - $date" -ForegroundColor Yellow
                Invoke-PnPSiteTemplate -Path $SiteTemplate
                Write-Host "Successfully applied Site Template: $SiteTemplate - $date" -ForegroundColor Green
            }
            catch {
                Write-Host "Failed to apply Site Template: $SiteTemplate - $date" -ForegroundColor Red
                throw $_
            }
        }
    }

    # Function to add SharePoint list items from corresponding CSV files in the Config folder
    function Add-SPOListItems {
        param (
            [Parameter(Mandatory = $true)]
            [string]$ConfigPath
        )
        process {
            Get-ChildItem -Path $ConfigPath -Filter *.csv | ForEach-Object {
                try {
                    $listName = $_.BaseName -replace ' Items$', ''  # Remove " Items" from listName
                    $csvPath = $_.FullName
                    Write-Host "Importing items to $listName from $csvPath - $date" -ForegroundColor Yellow
    
                    $dataTable = Import-Csv -Path $csvPath
                    $dataTable | ForEach-Object {
                        $hashTable = @{}
                        $_.PSObject.Properties | ForEach-Object {
                            $propertyName = $_.Name
                            $propertyValue = $_.Value
    
                            # Check if the file is 'Metadata - List UI Items.csv'
                            # and the property is 'ui_choices' or 'ui_visibility_mode'
                            if ($csvPath -match 'Metadata - List UI Items.csv' -and
                                ($propertyName -eq 'ui_choices' -or $propertyName -eq 'ui_visibility_mode')) {
                                $hashTable[$propertyName] = ($propertyValue -split ',\s*').Trim() # Split and Trim each value
                            } else {
                                $hashTable[$propertyName] = $propertyValue
                            }
                        }
                        # Adding list items only once per row after processing all columns
                        Add-PnPListItem -List $listName -Values $hashTable
                    }
                    Write-Host "Successfully imported items to $listName - $date" -ForegroundColor Green
                }
                catch {
                    Write-Host "Failed to import items to $listName from $csvPath - $date" -ForegroundColor Red
                    throw $_
                }
            }
        }
    }
    
    #endregion
}
# Main process: Connecting to SharePoint, applying template, and adding list items
PROCESS {
    # Connecting to SharePoint Online
    try {
        $Credentials = GetCredentials -Account $Account -Password $Password
        Connect-PnPOnline -Url $TargetSiteUrl -Credentials $Credentials
        Write-Host "Connected to $TargetSiteUrl - $date" -ForegroundColor Green
    }
    catch {
        Write-Host "Couldn't connect to $TargetSiteUrl - $date" -ForegroundColor Red
        throw $_
    }

    # Applying PnP Site Template
    try {
        $templatePath = Join-Path $configPath "SiteTemplate.xml"
        Update-PNPtemplate -SiteTemplate $templatePath
    }
    catch {
        Write-Host "Couldn't update the site template - $date" -ForegroundColor Red
        throw $_
    }

    # Adding SharePoint list items from CSV files
    try {
            
        Add-SPOListItems -ConfigPath $configPath
    }
    catch {
        Write-Host "Couldn't add the list items - $date" -ForegroundColor Red
        throw $_
    }
}
# Resetting the environment back to the original state
END {
    $ErrorActionPreference = $oldEAP
}