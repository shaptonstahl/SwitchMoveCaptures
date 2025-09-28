# Compile-time check for SwitchMoveCapturesGUI.ps1 using ScriptBlock::Create
$target = Join-Path $PSScriptRoot 'SwitchMoveCapturesGUI.ps1'
if (-not (Test-Path $target)) { Write-Host "Target not found: $target"; exit 2 }
$s = Get-Content -Raw -Encoding UTF8 -Path $target
try {
    [scriptblock]::Create($s) | Out-Null
    Write-Host 'PARSE_OK'
    exit 0
} catch {
    Write-Host 'PARSE_FAIL'
    $_ | Format-List * -Force
    exit 1
}