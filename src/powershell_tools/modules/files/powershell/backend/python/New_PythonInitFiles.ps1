# Import-SiblingPythonModulesToInit.ps1

"""
    .SYNOPSIS
    Generates __init__.py files in all subdirectories of a specified path to ensure Python recognizes them as packages.

    .DESCRIPTION
    Renew the current __init__.py with sibling module imports.
    if __init__.py does not exist, it will be created.
    
    Logic:
    1. receives a directory path as input. (folder path)
    2. Check the number of files is not equal to 0.
    3. 

"""

# unfinished



function Import-SiblingPythonModulesToInit {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('FullName', 'StartFolderPath')]
        [string]$Path
    )

    begin {
        Write-Verbose "Starting __init__.py generation"
    }

    process {
        if (-not (Test-Path $Path -PathType Container)) {
            throw "Path '$Path' does not exist or is not a directory."
        }

        Get-ChildItem -Path $Path -Directory -Recurse -Force |
        ForEach-Object {
            $initFile = Join-Path $_.FullName "__init__.py"

            if (-not (Test-Path $initFile)) {
                if ($PSCmdlet.ShouldProcess($initFile, "Create __init__.py")) {
                    New-Item -ItemType File -Path $initFile -Force | Out-Null
                    Write-Verbose "Created: $initFile"
                }
            }
        }
    }

    end {
        Write-Verbose "Finished __init__.py generation"
    }
}
