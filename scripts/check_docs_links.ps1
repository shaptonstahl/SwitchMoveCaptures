# Check Markdown links inside docs/ for broken relative targets
# - Checks all .md files under docs/
# - Verifies local relative links point to existing files
# - Skips external (http/https) and mailto links and intra-page anchors

if ($PSCommandPath) {
    $scriptDir = Split-Path -Parent $PSCommandPath
} elseif ($PSScriptRoot) {
    $scriptDir = $PSScriptRoot
} else {
    $scriptDir = Get-Location
}
$root = (Resolve-Path (Join-Path $scriptDir '..')).ProviderPath
$docs = Join-Path $root 'docs'
if (-not (Test-Path $docs)) { Write-Error "docs folder not found at $docs"; exit 2 }

$mdFiles = Get-ChildItem -Path $docs -Filter '*.md' -Recurse
$broken = @()
$checked = 0
$external = @()

$linkRegex = '\[.*?\]\(([^)]+)\)'

foreach ($f in $mdFiles) {
    $text = Get-Content -Raw -LiteralPath $f.FullName -Encoding UTF8
    [regex]::Matches($text, $linkRegex) | ForEach-Object {
        $raw = $_.Groups[1].Value.Trim()
        if ($raw -eq '') { return }
        # strip surrounding < > if any
        if ($raw.StartsWith('<') -and $raw.EndsWith('>')) { $raw = $raw.Substring(1,$raw.Length-2) }
        # drop fragment
        $linkNoFrag = $raw.Split('#')[0]
        # skip empty (anchor-only)
        if ($linkNoFrag -eq '') { return }
        # skip external and mailto
        if ($linkNoFrag -match '^[a-zA-Z][a-zA-Z0-9+.-]*:') {
            $external += @{file=$f.FullName; link=$raw}
            return
        }
        # resolve path: links starting with / are repo-root relative
        if ($linkNoFrag.StartsWith('/')) {
            $target = Join-Path $root ($linkNoFrag.TrimStart('/'))
        } else {
            $target = Join-Path $f.DirectoryName $linkNoFrag
        }
        # decode URL-encoding
        try { $target = [uri]::UnescapeDataString($target) } catch {}
        # normalize
        $resolved = Resolve-Path -LiteralPath $target -ErrorAction SilentlyContinue
        if ($resolved) { $target = $resolved.ProviderPath } else { $target = $null }
        if (-not $target) {
            $broken += @{file=$f.FullName; link=$raw}
        }
        $checked++
    }
}

Write-Host "Checked links: $checked"
Write-Host "External/skipped links: $($external.Count)"
if ($external.Count -gt 0) {
    Write-Host "Examples of external/skipped links:" -ForegroundColor Yellow
    $external | Select-Object -First 10 | ForEach-Object { Write-Host " - $($_.file) -> $($_.link)" }
}

if ($broken.Count -gt 0) {
    Write-Host "\nBroken links found:" -ForegroundColor Red
    $broken | ForEach-Object { Write-Host " - $($_.file) -> $($_.link)" }
    exit 1
} else {
    Write-Host "\nNo broken relative links detected." -ForegroundColor Green
    exit 0
}
