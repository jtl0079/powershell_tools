# 自动加载同目录下所有函数
$publicFunctions = Get-ChildItem -Path $PSScriptRoot -Filter '*.ps1' -File

foreach ($fn in $publicFunctions) {
    . $fn.FullName
}
# --- IGNORE ---