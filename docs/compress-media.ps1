<#
.SYNOPSIS
    Compresses images to AVIF with responsive sizes and videos to WebM.
.PARAMETER Force
    Force recompression of all files
.EXAMPLE
    .\compress-media.ps1
    .\compress-media.ps1 -Force
#>

param([switch]$Force = $false)

# Configuration
$ContentDir = "assets\content"
$OutputDir = "assets\content_compressed"
$ImageSizes = @(320, 640, 960, 1280)
$AVIFQuality = 30
$AVIFSpeed = 6
$VideoQuality = 32

# File type definitions
$ImageExtensions = @('.png', '.jpg', '.jpeg', '.gif', '.bmp', '.avif', '.webp')
$VideoExtensions = @('.mp4', '.mov', '.avi', '.webm', '.mkv', '.flv')

# Color output
function Write-Status { param($Msg) Write-Host "[INFO] $Msg" -ForegroundColor Cyan }
function Write-Success { param($Msg) Write-Host "[OK] $Msg" -ForegroundColor Green }
function Write-Warn { param($Msg) Write-Host "[WARN] $Msg" -ForegroundColor Yellow }
function Write-Err { param($Msg) Write-Host "[ERROR] $Msg" -ForegroundColor Red }

# Check dependencies
function Test-Deps {
    $missing = @()
    try { $null = magick -version 2>&1 } catch { $missing += "ImageMagick" }
    try { $null = avifenc --help 2>&1 } catch { $missing += "avifenc" }
    try { $null = ffmpeg -version 2>&1 } catch { $missing += "ffmpeg" }
    
    if ($missing.Count -gt 0) {
        Write-Err "Missing: $($missing -join ', ')"
        Write-Host ""
        Write-Host "Install from:"
        Write-Host "  ImageMagick: https://imagemagick.org/script/download.php"
        Write-Host "  avifenc: https://github.com/AOMediaCodec/libavif/releases"
        Write-Host "  ffmpeg: https://ffmpeg.org/download.html"
        exit 1
    }
}

# Create output dirs
function Init-Output {
    param($SrcDir, $OutDir)
    Get-ChildItem -Path $SrcDir -Recurse -Directory | ForEach-Object {
        $relPath = $_.FullName.Substring($SrcDir.Length).TrimStart('\')
        $target = Join-Path $OutDir $relPath
        if (-not (Test-Path $target)) {
            New-Item -ItemType Directory -Path $target -Force | Out-Null
        }
    }
}

# Check if image needs compression
function Test-ImageNeeded {
    param($SrcFile, $OutDir)
    if ($Force) { return $true }
    $base = [System.IO.Path]::GetFileNameWithoutExtension($SrcFile)
    foreach ($w in $ImageSizes) {
        if (-not (Test-Path (Join-Path $OutDir "$base-${w}w.avif"))) { return $true }
    }
    if (-not (Test-Path (Join-Path $OutDir "$base-fallback.webp"))) { return $true }
    return $false
}

# Compress image
function Compress-Img {
    param($SrcFile, $OutDir)
    $base = [System.IO.Path]::GetFileNameWithoutExtension($SrcFile)
    $ext = [System.IO.Path]::GetExtension($SrcFile)
    Write-Status "Processing: $base$ext"
    
    # Create AVIF sizes
    foreach ($w in $ImageSizes) {
        $out = Join-Path $OutDir "$base-${w}w.avif"
        if ($Force -or -not (Test-Path $out)) {
            Write-Host "  -> ${w}w AVIF..." -NoNewline
            try {
                $temp = [System.IO.Path]::GetTempFileName() + ".png"
                $null = magick "$SrcFile" -resize "${w}x>" "$temp" 2>&1
                if (Test-Path $temp) {
                    $null = avifenc "$temp" "$out" --min 0 --max 63 -a end-usage=q -a cq-level=$AVIFQuality -a tune=ssim --jobs 4 -s $AVIFSpeed 2>&1
                    Remove-Item $temp -Force -ErrorAction SilentlyContinue
                }
                if (Test-Path $out) {
                    $size = [math]::Round((Get-Item $out).Length / 1KB, 1)
                    Write-Host " ${size}KB" -ForegroundColor Green
                }
            } catch {
                Write-Host " Failed: $_" -ForegroundColor Red
            }
        }
    }
    
    # Create WebP fallback
    $webp = Join-Path $OutDir "$base-fallback.webp"
    if ($Force -or -not (Test-Path $webp)) {
        Write-Host "  -> WebP..." -NoNewline
        try {
            $max = $ImageSizes[-1]
            $null = magick "$SrcFile" -resize "${max}x>" -quality 85 "$webp" 2>&1
            if (Test-Path $webp) {
                $size = [math]::Round((Get-Item $webp).Length / 1KB, 1)
                Write-Host " ${size}KB" -ForegroundColor Green
            }
        } catch {
            Write-Host " Failed: $_" -ForegroundColor Red
        }
    }
    Write-Success "Done: $base"
}

# Check if video needs compression
function Test-VideoNeeded {
    param($SrcFile, $OutDir)
    if ($Force) { return $true }
    $base = [System.IO.Path]::GetFileNameWithoutExtension($SrcFile)
    $outWebm = Join-Path $OutDir "$base.webm"
    return -not (Test-Path $outWebm)
}

# Compress video (including already-webm files)
function Compress-Vid {
    param($SrcFile, $OutDir)
    $base = [System.IO.Path]::GetFileNameWithoutExtension($SrcFile)
    $ext = [System.IO.Path]::GetExtension($SrcFile)
    $out = Join-Path $OutDir "$base.webm"
    
    if ($Force -or -not (Test-Path $out)) {
        Write-Status "Processing: $base$ext"
        Write-Host "  -> WebM VP9..." -NoNewline
        try {
            # Compress even if already .webm (re-encode with better settings)
            $null = ffmpeg -i "$SrcFile" -c:v libvpx-vp9 -b:v 0 -crf $VideoQuality -deadline good -an "$out" -y 2>&1
            if (Test-Path $out) {
                $orig = [math]::Round((Get-Item $SrcFile).Length / 1MB, 2)
                $comp = [math]::Round((Get-Item $out).Length / 1MB, 2)
                if ($orig -gt 0) {
                    $save = [math]::Round((1 - $comp / $orig) * 100, 1)
                    Write-Host " ${orig}MB -> ${comp}MB (-${save}%)" -ForegroundColor Green
                } else {
                    Write-Host " ${comp}MB" -ForegroundColor Green
                }
            }
        } catch {
            Write-Host " Failed: $_" -ForegroundColor Red
        }
        Write-Success "Done: $base.webm"
    } else {
        Write-Warn "Skipped: $base.webm (already exists)"
    }
}

# Copy non-media file
function Copy-Other {
    param($SrcFile, $OutDir)
    $fileName = [System.IO.Path]::GetFileName($SrcFile)
    $outFile = Join-Path $OutDir $fileName
    
    if ($Force -or -not (Test-Path $outFile)) {
        Write-Status "Copying: $fileName"
        try {
            Copy-Item $SrcFile $outFile -Force
            Write-Success "Copied: $fileName"
        } catch {
            $errMsg = $_.Exception.Message
            Write-Err "Failed to copy ${fileName}: $errMsg"
        }
    } else {
        Write-Warn "Skipped: $fileName (already exists)"
    }
}

# Determine file type
function Get-FileType {
    param($File)
    $ext = $File.Extension.ToLower()
    if ($ImageExtensions -contains $ext) { return "image" }
    if ($VideoExtensions -contains $ext) { return "video" }
    return "other"
}

# Main
Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Media Compression" -ForegroundColor Cyan  
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

Write-Status "Checking dependencies..."
Test-Deps
Write-Success "Dependencies OK"
Write-Host ""

if (-not (Test-Path $ContentDir)) {
    Write-Err "Not found: $ContentDir"
    exit 1
}

# Ensure output directory exists
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

Write-Status "Creating output structure..."
$ContentDirResolved = (Resolve-Path $ContentDir).Path
$OutputDirResolved = (Resolve-Path $OutputDir).Path
Init-Output $ContentDirResolved $OutputDirResolved
Write-Success "Structure ready"
Write-Host ""

# Process all files
Write-Host "=== PROCESSING ALL FILES ===" -ForegroundColor Cyan
Write-Host ""

$allFiles = Get-ChildItem -Path $ContentDir -Recurse -File
$imgCnt = 0
$vidCnt = 0
$otherCnt = 0
$skipCnt = 0

foreach ($file in $allFiles) {
    # Determine output directory
    $relPath = $file.DirectoryName.Substring($ContentDirResolved.Length).TrimStart('\')
    $outDir = Join-Path $OutputDirResolved $relPath
    
    # Process based on file type
    $fileType = Get-FileType $file
    
    switch ($fileType) {
        "image" {
            if (Test-ImageNeeded $file.FullName $outDir) {
                Compress-Img $file.FullName $outDir
                $imgCnt++
            } else {
                Write-Warn "Skipped: $($file.Name) (already compressed)"
                $skipCnt++
            }
        }
        "video" {
            if (Test-VideoNeeded $file.FullName $outDir) {
                Compress-Vid $file.FullName $outDir
                $vidCnt++
            } else {
                Write-Warn "Skipped: $($file.Name) (already exists)"
                $skipCnt++
            }
        }
        "other" {
            Copy-Other $file.FullName $outDir
            $otherCnt++
        }
    }
}

# Summary
Write-Host ""
Write-Host "======================================" -ForegroundColor Green
Write-Host "  COMPLETE" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""
Write-Host "Images compressed: $imgCnt"
Write-Host "Videos compressed: $vidCnt"
Write-Host "Other files copied: $otherCnt"
Write-Host "Skipped (exist): $skipCnt"
Write-Host ""
Write-Host "Output: $OutputDir"
Write-Host ""
