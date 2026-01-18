


function Get-PythonFunctionNameInFile {
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
        # ______ validations ______
        # Validate file existence
        if (-not (Test-Path $Path)) {
            throw "[Get-PythonFunctionNameInFile] File does not exist: $Path"
        }

        # Validate file extension
        if ((Get-Item $Path).Extension -ne '.py') {
            throw "[Get-PythonFunctionNameInFile] Not a python file: $Path"
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
            Write-Verbose ("[Get-PythonFunctionNameInFile] Extracted functions: {0}" -f ($foundFunctions -join ', '))
        }
        else {
            Write-Verbose ("[Get-PythonFunctionNameInFile] No functions found.")
        }
    }
}

# Testing example:
# . C:\_my\powershell_tools\src\powershell_tools\modules\files\powershell\backend\python\Get_PythonFunctionNameInFile.ps1; `
# Get-PythonFunctionName "C:\_my\python_tools\src\python_tools\core\network\primitive\mac_to_hex_string.py" -Verbose
