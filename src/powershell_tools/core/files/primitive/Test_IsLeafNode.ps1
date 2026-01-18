function Get-PythonFunctionName {
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
        # ───────── validation ─────────
        if (-not (Test-Path $Path)) {
            throw "[Get-PythonFunctionName] File does not exist: $Path"
        }

        if ((Get-Item $Path).Extension -ne '.py') {
            throw "[Get-PythonFunctionName] Not a python file: $Path"
        }

        # ───────── retrieve and parse ─────────
        $lines = Get-Content $Path
        $lineNumber = 0

        foreach ($line in $lines) {
            $lineNumber++

            if ($line -match '^\s*def\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*\(') {
                $name = $matches[1]

                # pipeline 输出（核心行为）
                $name

                # 收集用于 end 的 verbose
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
