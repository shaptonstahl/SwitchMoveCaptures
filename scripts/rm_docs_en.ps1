$p = Join-Path $PSScriptRoot '..\docs\en'
if (Test-Path $p) {
    Remove-Item -LiteralPath $p -Recurse -Force
    Write-Output "Removed: $p"
} else {
    Write-Output "Not found: $p"
}
