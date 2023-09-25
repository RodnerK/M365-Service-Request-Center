<#
.SYNOPSIS
This script performs an update on CanvasApp by replacing old site URLs with new ones, packs the updated app files, and moves them to their corresponding locations, followed by compressing the solution files.

.DESCRIPTION
- The script sets the script environment and initializes the required variables.
- It then runs the Update-CanvasApp function, which is the core function performing all the needed operations.
- The script handles errors gracefully and resets the environment back to the original state after execution.

.PARAMETER TargetSiteUrl
The new target Site URL that needs to be updated in the CanvasApp. This parameter is mandatory.

.EXAMPLE
PS> .\Update-SolutionFiles.ps1 -TargetSiteUrl "https://newSiteUrl.com"

.NOTES
File Name      : ScriptName.ps1
Prerequisite   : PowerShell V5.1
#>

[CmdletBinding()]
PARAM (
    [Parameter(Mandatory = $true)]
    [string]$TargetSiteUrl = [System.String]::Empty
)
# Initializing the script environment
BEGIN {
    # Setting up initial conditions and variables
    Set-Location $PSScriptRoot
    $oldEAP = $ErrorActionPreference
    $ErrorActionPreference = "Stop"
    $RootFolderPath = (Get-Item $PSScriptRoot).Parent.FullName

    function Update-CanvasApp {
        param (
            [Parameter(Mandatory = $true)]
            [string]$SiteUrl,
            [string]$RootFolderPath
        )
        
        process {
            if ([string]::IsNullOrWhiteSpace($SiteUrl)) {
                Write-Error "SiteUrl cannot be empty or null."
                return
            }

            # Replacing old URLs with new in connection json files
            $OpenConnectionsPath = "$RootFolderPath\(Unpacked) CanvasApps\new_m365servicerequestcenter_afdf0_DocumentUri\Connections\Connections.json"
            (Get-Content $OpenConnectionsPath) -replace 'https://development538.sharepoint.com/sites/PowerAppsDev', $SiteUrl | Set-Content $OpenConnectionsPath
    
            # Replacing old URLs with new in all data source json files
            $DataSourcesFolderPath = "$RootFolderPath\(Unpacked) CanvasApps\new_m365servicerequestcenter_afdf0_DocumentUri\DataSources"
            Get-ChildItem -Path $DataSourcesFolderPath -Filter "*.json" | ForEach-Object {
                (Get-Content $_.FullName) -replace 'https://development538.sharepoint.com/sites/PowerAppsDev', $SiteUrl | Set-Content $_.FullName
                Write-Verbose "Updated: $($_.Name)."
            }
    
            # Packing the updated app files
            Set-Location "$RootFolderPath\(Unpacked) CanvasApps"
            & pac canvas pack --sources new_m365servicerequestcenter_afdf0_DocumentUri --msapp new_m365servicerequestcenter_afdf0_DocumentUri.msapp
            Write-Verbose "App packed."
    
            # Moving the updated app to the destination
            $Destination = "$RootFolderPath\(Unpacked) Solutions\Microsoft365Requests_1_0_0_0\CanvasApps"
            Move-Item -Path ".\new_m365servicerequestcenter_afdf0_DocumentUri.msapp" -Destination $Destination -Force
            Write-Verbose "App moved to '$Destination'."
    
            # Compressing the updated solution files
            $SourcePath = "$RootFolderPath\(Unpacked) Solutions\Microsoft365Requests_1_0_0_0\*"
            $DestinationPath = "$RootFolderPath\(Packed) Solutions\Microsoft365Requests_1_0_0_0.zip"
            Compress-Archive -Path $SourcePath -DestinationPath $DestinationPath -Force
            Write-Verbose "Solution files compressed."
    
            # Moving the compressed solution to the destination
            Move-Item -Path $DestinationPath -Destination "$RootFolderPath\(Packed) Solutions" -Force
            Write-Verbose "Compressed solution moved."

            Write-Host "Process Completed Successfully." -ForegroundColor Green
        }
    }
}
# Main Process
PROCESS {
    try {
        Update-CanvasApp -SiteUrl $TargetSiteUrl -RootFolderPath $RootFolderPath
    }
    catch {
        Write-Error "An error occurred: $_"
    }
}  
# Resetting the environment back to the original state
END {
    $ErrorActionPreference = $oldEAP
}
