function Update-ModuleEntryPsm1 {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [Alias('GeneratedModuleFileName')]
        [string]$ModuleName

    )

    # ---- validations ----
    if (-not (Test-Path $Path)) {
        throw "[Update-ModuleEntryPsm1] Path does not exist: $Path"
    }

    if (-not (Get-Item $Path).PSIsContainer) {
        throw "[Update-ModuleEntryPsm1] Path is not a directory: $Path"
    }

    $psm1Path = Join-Path $Path "$ModuleName.psm1"

    $content = @'
# ==================================================
# [Update-ModuleEntryPsm1]
# Auto-generated runtime loader
# DO NOT EDIT MANUALLY
# ==================================================

# auto load the public functions inside the same folder

# include all .ps1 files in the same folder
$publicFunctions = Get-ChildItem -Path $PSScriptRoot -Filter '*.ps1' -File

# load each function inside this psm1 
foreach ($fn in $publicFunctions) {
    . $fn.FullName
}
'@

    if ($PSCmdlet.ShouldProcess($psm1Path, "Write runtime include psm1")) {
        $content | Set-Content -Path $psm1Path -Encoding UTF8
    }

    Write-Verbose "[New-RuntimeIncludePsm1] Generated $psm1Path"
}
