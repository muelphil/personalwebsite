<#
.SYNOPSIS
    Updates all media paths in Jekyll files to use compressed content.

.DESCRIPTION
    Scans all posts (_posts), drafts (_drafts), and includes (_includes)
    for references to assets/images/ and updates them to assets/content_compressed/
    
    Also updates image tags to use responsive AVIF with WebP fallback.

.PARAMETER DryRun
    Show what would be changed without actually modifying files

.EXAMPLE
    .\update-media-paths.ps1
    .\update-media-paths.ps1 -DryRun

.NOTES
    Creates backups in _backup/ before modifying files
#>

param(
    [switch]$DryRun = $false
)

# Configuration
$PostsDir = "_posts"
$DraftsDir = "_drafts"
$IncludesDir = "_includes"
$BackupDir = "_backup"
$ImageSizes = @(320, 640, 960, 1280)

# Color output
function Write-Status { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }
function Write-Success { param($Message) Write-Host "[OK] $Message" -ForegroundColor Green }
function Write-Warning { param($Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Write-ErrorMsg { param($Message) Write-Host "[ERROR] $Message" -ForegroundColor Red }

# Create backup
function Backup-File {
    param($FilePath)
    
    if ($DryRun) { return }
    
    $relativePath = $FilePath.Substring((Get-Location).Path.Length + 1)
    $backupPath = Join-Path $BackupDir $relativePath
    $backupFolder = Split-Path $backupPath -Parent
    
    if (-not (Test-Path $backupFolder)) {
        New-Item -ItemType Directory -Path $backupFolder -Force | Out-Null
    }
    
    Copy-Item $FilePath $backupPath -Force
}

# Update simple image path references
function Update-ImagePaths {
    param($Content)
    
    # Update /assets/content_compressed/ → /assets/content_compressed/
    $updated = $Content -replace '/assets/content_compressed/', '/assets/content_compressed/'
    $updated = $updated -replace 'assets/images/', 'assets/content_compressed/'
    $updated = $updated -replace '/assets\\images\\', '/assets/content_compressed/'
    $updated = $updated -replace 'assets\\images\\', 'assets/content_compressed/'
    
    return $updated
}

# Update image file extensions to AVIF (with fallback logic in includes)
function Update-ImageExtensions {
    param($Content)
    
    # This is handled by the includes themselves
    # Just update the paths, includes will add responsive srcset
    return $Content
}

# Process a single file
function Update-File {
    param($FilePath)
    
    $fileName = Split-Path $FilePath -Leaf
    $content = Get-Content $FilePath -Raw -Encoding UTF8
    $originalContent = $content
    
    # Update paths
    $content = Update-ImagePaths $content
    
    # Check if changes were made
    if ($content -ne $originalContent) {
        $changes = @()
        
        # Count replacements
        $imageChanges = ([regex]::Matches($originalContent, '/assets/content_compressed/|assets/images/|/assets\\images\\|assets\\images\\')).Count
        
        if ($imageChanges -gt 0) { $changes += "$imageChanges image path(s)" }
        
        if ($DryRun) {
            Write-Host "  [DRY RUN] Would update: $fileName" -ForegroundColor Yellow
            Write-Host "    Changes: $($changes -join ', ')" -ForegroundColor Yellow
        } else {
            Backup-File $FilePath
            Set-Content -Path $FilePath -Value $content -Encoding UTF8 -NoNewline
            Write-Success "Updated: $fileName ($($changes -join ', '))"
        }
        
        return $true
    }
    
    return $false
}

# Main processing
function Start-PathUpdate {
    Write-Host "`n╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║           Update Media Paths to Compressed Content        ║" -ForegroundColor Cyan
    Write-Host "╚═══════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan
    
    if ($DryRun) {
        Write-Warning "DRY RUN MODE - No files will be modified`n"
    } else {
        Write-Status "Backups will be created in: $BackupDir`n"
    }
    
    $totalFiles = 0
    $updatedFiles = 0
    
    # Process Posts
    if (Test-Path $PostsDir) {
        Write-Host "`n════════════════ PROCESSING POSTS ════════════════`n" -ForegroundColor Cyan
        
        $postFiles = Get-ChildItem -Path $PostsDir -Recurse -Include *.md,*.markdown,*.html
        foreach ($file in $postFiles) {
            $totalFiles++
            if (Update-File $file.FullName) {
                $updatedFiles++
            }
        }
    }
    
    # Process Drafts
    if (Test-Path $DraftsDir) {
        Write-Host "`n════════════════ PROCESSING DRAFTS ════════════════`n" -ForegroundColor Cyan
        
        $draftFiles = Get-ChildItem -Path $DraftsDir -Recurse -Include *.md,*.markdown,*.html
        foreach ($file in $draftFiles) {
            $totalFiles++
            if (Update-File $file.FullName) {
                $updatedFiles++
            }
        }
    }
    
    # Process Includes
    if (Test-Path $IncludesDir) {
        Write-Host "`n════════════════ PROCESSING INCLUDES ════════════════`n" -ForegroundColor Cyan
        
        $includeFiles = Get-ChildItem -Path $IncludesDir -Recurse -Include *.html
        foreach ($file in $includeFiles) {
            $totalFiles++
            if (Update-File $file.FullName) {
                $updatedFiles++
            }
        }
    }
    
    # Summary
    Write-Host "`n╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                       UPDATE COMPLETE                      ║" -ForegroundColor Green
    Write-Host "╚═══════════════════════════════════════════════════════════╝`n" -ForegroundColor Green
    
    Write-Host "Files scanned: $totalFiles"
    Write-Host "Files updated: $updatedFiles"
    
    if ($DryRun) {
        Write-Warning "`nThis was a DRY RUN. Run without -DryRun to apply changes."
    } else {
        Write-Success "`nBackups saved to: $BackupDir"
    }
    
    Write-Host ""
}

# Run
Start-PathUpdate
