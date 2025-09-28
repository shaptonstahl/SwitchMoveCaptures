<#
Build static HTML docs with MkDocs.
- Installs mkdocs into the current user Python environment if missing.
- Builds into ./site

Usage:
  powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build-docs.ps1
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-PythonPath {
    $py = Get-Command python -ErrorAction SilentlyContinue
    if (-not $py) { throw 'Python not found on PATH. Install Python 3.8+ and try again.' }
    return $py.Source
}

function Get-OrInstall-MkDocs {
    try {
        & python -c "import mkdocs" 2>$null
        return
    } catch {
        Write-Host 'mkdocs not found in Python environment. Installing via pip (user install)...'
        & python -m pip install --user mkdocs
    }
}

function Get-OrInstall-MkDocsMaterial {
    try {
        & python -c "import mkdocs_material" 2>$null
        return
    } catch {
        Write-Host 'mkdocs-material not found. Installing via pip (user install)...'
        & python -m pip install --user mkdocs-material
    }
}

Write-Host 'Checking for Python...'
$python = Get-PythonPath
Write-Host "Using Python at: $python"

Write-Host 'Ensuring mkdocs is installed...'
Get-OrInstall-MkDocs
Write-Host 'Ensuring mkdocs-material theme is installed...'
Get-OrInstall-MkDocsMaterial

Write-Host 'Building site with mkdocs...'
& python -m mkdocs build --site-dir site
Write-Host 'MkDocs build complete. Output in ./site'
