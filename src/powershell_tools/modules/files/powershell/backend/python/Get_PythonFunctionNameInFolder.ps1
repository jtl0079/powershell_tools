


function Get-PythonFunctionNameInFolder {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('FullPath')]
        [string]$Path,

        [switch]$Recurse
    )

    begin {
        Write-Verbose "[Get-PythonFunctionNameInFolder] Start scanning folder"
    }

    process {
        # ---- validations ----
        if (-not (Test-Path $Path)) {
            throw "[Get-PythonFunctionNameInFolder] Path does not exist: $Path"
        }

        if (-not (Get-Item $Path).PSIsContainer) {
            throw "[Get-PythonFunctionNameInFolder] Path is not a folder: $Path"
        }

        # ---- collect .py files ----
        $files = Get-ChildItem `
            -Path $Path `
            -Filter '*.py' `
            -File `
            -Recurse:$Recurse

        foreach ($file in $files) {

            Write-Verbose "[Get-PythonFunctionNameInFolder] Processing $($file.FullName)"

            try {
                $functions = Get-PythonFunctionNameInFile -Path $file.FullName

                foreach ($fn in $functions) {
                    [pscustomobject]@{
                        File     = $file.Name
                        FullPath = $file.FullName
                        Function = $fn
                    }
                }
            }
            catch {
                Write-Warning $_
            }
        }
    }

    end {
        Write-Verbose "[Get-PythonFunctionNameInFolder] Done"
    }
}
