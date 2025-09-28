# Remove entire locale dirs under docs (non-recoverable in this script)
$root = Join-Path $PSScriptRoot '..\docs'
$dirs = @('es','fr','de','ja','zh')
foreach ($d in $dirs) {
    $p = Join-Path $root $d
    if (Test-Path $p) {
        try {
            Remove-Item -LiteralPath $p -Recurse -Force
            Write-Host "Removed: $p"
        } catch {
            Write-Host "Failed to remove: $p`n$_"
        }
    } else { Write-Host "Not present: $p" }
}