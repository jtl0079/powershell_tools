

function Test-IsLeafNode {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('FullPath')]
        [string]$Path
    )

    process {
        Write-Verbose "[Test-IsLeafNode] Testing leaf node: $Path"

        if (-not (Test-Path $Path)) {
            Write-Error "[Test-IsLeafNode] Path not found: $Path"
            return
        }

        $item = Get-Item $Path

        # file Definitely leaf node
        if (-not $item.PSIsContainer) {
            return $true
        }

        $children = Get-ChildItem -Path $Path -Force -ErrorAction SilentlyContinue

        return ($children.Count -eq 0)
    }

    
    
}
