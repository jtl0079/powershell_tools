function Get-PythonFunctionNameInFiles {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('FullName')]
        [string]$Path
    )

    begin {
        $foundFunctions = @()
    }

    process {
        if (-not (Test-Path $Path)) {
            throw "File does not exist: $Path"
        }

        if ((Get-Item $Path).Extension -ne '.py') {
            throw "Not a python file: $Path"
        }

        $lines = Get-Content $Path
        $lineNumber = 0

        foreach ($line in $lines) {
            $lineNumber++

            if ($line -match '^\s*def\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*\(') {
                $name = $matches[1]


                $name


                $foundFunctions += $name
            }
        }
    }

    end {
        if ($foundFunctions.Count -gt 0) {
            Write-Verbose ("Extracted functions: {0}" -f ($foundFunctions -join ', '))
        }
        else {
            Write-Verbose "No functions found."
        }
    }
}

# Testing example:
# . C:\_my\powershell_tools\src\powershell_tools\modules\files\powershell\backend\python\Get_PythonFunctionName.ps1; `
# Get-PythonFunctionName "C:\_my\python_tools\src\python_tools\core\network\primitive\mac_to_hex_string.py" -Verbose
#
#