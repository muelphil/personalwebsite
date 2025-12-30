# Media Compression - Quick Start

## Setup (One Time)

### 1. Install Tools
```powershell
# Using Chocolatey
choco install imagemagick ffmpeg

# Download avifenc from:
# https://github.com/AOMediaCodec/libavif/releases
# Add to PATH
```

### 2. Verify Installation
```powershell
magick -version   # Should show ImageMagick version
avifenc --help    # Should show avifenc help
ffmpeg -version   # Should show FFmpeg version
```

## Daily Workflow

### Adding New Media

```powershell
# 1. Add your images/videos to assets/content/
#    Example: assets/content/MyProject/photo.png

# 2. Run compression
cd docs
.\compress-media.ps1

# 3. Reference in your post (use original path!)
# Front matter or content:
# title-image: '/assets/content/MyProject/photo.png'
# {% include image.html url="/assets/content/MyProject/photo.png" description="..." %}

# 4. Build and preview
bundle exec jekyll serve

# Done! Jekyll automatically uses compressed versions.
```

## First Time Setup (After Script Creation)

```powershell
# Update all existing posts to use compressed paths
cd docs
.\update-media-paths.ps1 -DryRun  # Preview changes
.\update-media-paths.ps1          # Apply changes (creates backup)
```

## What Happens

### Before
```
/assets/content/photo.png (2.5 MB)
→ Loaded directly
```

### After
```
/assets/content/photo.png (source, not served)
→ Compressed to:
   - photo-320w.avif (20 KB)
   - photo-640w.avif (45 KB)  
   - photo-960w.avif (95 KB)
   - photo-1280w.avif (150 KB)
   - photo-fallback.webp (180 KB)

→ Jekyll serves appropriate size
→ Browser downloads 45-150 KB instead of 2.5 MB
```

## Commands

```powershell
# Compress new media only (fast)
.\compress-media.ps1

# Recompress everything (slow)
.\compress-media.ps1 -Force

# Update file paths (one-time)
.\update-media-paths.ps1

# Preview path changes without modifying
.\update-media-paths.ps1 -DryRun
```

## Results

✅ 80-95% file size reduction  
✅ Faster page loads  
✅ Better Lighthouse scores  
✅ Improved SEO  
✅ Lower hosting costs  

## Support

See `MEDIA_COMPRESSION_GUIDE.md` for complete documentation.
