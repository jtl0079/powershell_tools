# Import-SiblingPythonModulesToInit.ps1

"""
    .SYNOPSIS
    Generates __init__.py files in all subdirectories of a specified path to ensure Python recognizes them as packages.

    .DESCRIPTION
    This function traverses the directory structure starting from the provided path and creates an empty __init__.py file in each subdirectory that does not already contain one. This is useful for organizing Python modules into packages.


"""





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
