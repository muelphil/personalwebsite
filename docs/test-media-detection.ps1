<#
.SYNOPSIS
    Tests media compression script logic without dependencies
#>

param([switch]$Force = $false)

$ContentDir = "assets\content"
$OutputDir = "assets\content_compressed"
$ImageExtensions = @('.png', '.jpg', '.jpeg', '.gif', '.bmp')
$VideoExtensions = @('.mp4', '.mov', '.avi', '.webm', '.mkv', '.flv')

function Write-Status { param($Msg) Write-Host "[INFO] $Msg" -ForegroundColor Cyan }
function Write-Success { param($Msg) Write-Host "[OK] $Msg" -ForegroundColor Green }
function Write-Warn { param($Msg) Write-Host "[WARN] $Msg" -ForegroundColor Yellow }

function Get-FileType {
    param($File)
    $ext = $File.Extension.ToLower()
    if ($ImageExtensions -contains $ext) { return "image" }
    if ($VideoExtensions -contains $ext) { return "video" }
    return "other"
}

Write-Host ""
Write-Host "=== TESTING FILE DETECTION ===" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $ContentDir)) {
    Write-Host "Content directory not found" -ForegroundColor Red
    exit 1
}

$allFiles = Get-ChildItem -Path $ContentDir -Recurse -File
$imgCnt = 0
$vidCnt = 0
$otherCnt = 0

Write-Host "Files found in content:" -ForegroundColor Yellow
Write-Host ""

foreach ($file in $allFiles) {
    $fileType = Get-FileType $file
    $relPath = $file.FullName.Substring((Resolve-Path $ContentDir).Path.Length + 1)
    
    switch ($fileType) {
        "image" {
            Write-Host "  [IMAGE] $relPath" -ForegroundColor Green
            $imgCnt++
        }
        "video" {
            Write-Host "  [VIDEO] $relPath" -ForegroundColor Cyan
            $vidCnt++
        }
        "other" {
            Write-Host "  [OTHER] $relPath" -ForegroundColor Yellow
            $otherCnt++
        }
    }
}

Write-Host ""
Write-Host "=== SUMMARY ===" -ForegroundColor Green
Write-Host ""
Write-Host "Images: $imgCnt"
Write-Host "Videos: $vidCnt (including .webm)"
Write-Host "Other: $otherCnt"
Write-Host "Total: $($allFiles.Count)"
Write-Host ""
