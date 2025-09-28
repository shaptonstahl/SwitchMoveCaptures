param(
    [int]$start = 440,
    [int]$end = 620
)
$path = Join-Path $PSScriptRoot 'SwitchMoveCapturesGUI.ps1'
if (-not (Test-Path $path)) { Write-Host "Missing $path"; exit 2 }
$lines = Get-Content -Path $path
for ($i = $start; $i -le $end -and $i -le $lines.Count; $i++) {
    $ln = $lines[$i-1]
    $display = $ln
    # Replace tabs with \t for visibility
    $display = $display -replace "`t", "\\t"
    Write-Host ("{0,4}: {1}" -f $i, $display)
    # show non-ascii chars
    $chars = $ln.ToCharArray()
    $nonAscii = $chars | Where-Object { [int]$_ -gt 127 }
    if ($nonAscii) {
        Write-Host "      Non-ASCII chars: " -NoNewline
        foreach ($c in $nonAscii) { Write-Host ("U+{0:X4}" -f [int]$c) -NoNewline; Write-Host " " -NoNewline }
        Write-Host
    }
}
