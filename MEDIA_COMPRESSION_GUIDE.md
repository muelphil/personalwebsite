# Media Compression Workflow

## Overview

This Jekyll site uses an automated media compression workflow that generates responsive AVIF images and WebM videos for optimal web performance.

## Directory Structure

```
docs/
├── assets/
│   ├── content/              ← Original media (source)
│   │   ├── Oskam/
│   │   ├── Illumination/
│   │   └── ...
│   └── content_compressed/   ← Generated compressed media
│       ├── Oskam/
│       │   ├── image-320w.avif
│       │   ├── image-640w.avif
│       │   ├── image-960w.avif
│       │   ├── image-1280w.avif
│       │   ├── image-fallback.webp
│       │   └── video.webm
│       └── ...
├── compress-media.ps1        ← Compression script
└── update-media-paths.ps1    ← Path updater script
```

## Prerequisites

### Required Tools

1. **ImageMagick** - Image resizing
   - Download: https://imagemagick.org/script/download.php
   - Verify: `magick -version`

2. **avifenc** - AVIF encoding
   - Download: https://github.com/AOMediaCodec/libavif/releases
   - Verify: `avifenc --help`

3. **ffmpeg** - Video compression
   - Download: https://ffmpeg.org/download.html
   - Verify: `ffmpeg -version`

### Installation (Windows)

```powershell
# Using Chocolatey (recommended)
choco install imagemagick
choco install ffmpeg

# Download avifenc manually from GitHub releases
# Add to PATH
```

## Usage

### Step 1: Add New Media

Place original images/videos in `assets/content/`:

```
assets/content/MyProject/photo.png
assets/content/MyProject/video.mp4
```

### Step 2: Run Compression

```powershell
cd docs
.\compress-media.ps1
```

**Options:**
- Default: Only compresses new/missing files (fast)
- `-Force`: Recompresses all files (slow)

```powershell
.\compress-media.ps1 -Force  # Recompress everything
```

### Step 3: Update Paths (One-time)

After first compression, update all file references:

```powershell
# Dry run (preview changes)
.\update-media-paths.ps1 -DryRun

# Apply changes (creates backups)
.\update-media-paths.ps1
```

This updates:
- All posts in `_posts/`
- All drafts in `_drafts/`
- All includes in `_includes/`

Backups are saved to `_backup/`

## What Gets Generated

### Images (PNG/JPG)

**Input:** `photo.png` (2.5 MB)

**Output:**
- `photo-320w.avif` (~20 KB) - Mobile portrait
- `photo-640w.avif` (~45 KB) - Mobile landscape
- `photo-960w.avif` (~95 KB) - Tablet
- `photo-1280w.avif` (~150 KB) - Desktop
- `photo-fallback.webp` (~180 KB) - WebP fallback

**Total:** ~490 KB (80% reduction)

### Videos (MP4/MOV/AVI)

**Input:** `video.mp4` (45 MB)

**Output:**
- `video.webm` (~8 MB) - VP9 codec, CRF 32

**Total:** ~8 MB (82% reduction)

## Image Compression Settings

### AVIF Quality
- **CQ Level:** 30 (Range: 0-63, lower = better quality)
- **Speed:** 6 (Range: 0-10, higher = faster)
- **Tune:** SSIM (perceptual quality)

### Responsive Sizes
- **320w:** Mobile phones (portrait)
- **640w:** Mobile phones (landscape), fallback
- **960w:** Tablets
- **1280w:** Desktop/laptop screens

### WebP Fallback
- **Quality:** 85%
- **Size:** 1280px max width
- **Purpose:** Safari/older browser support

## Video Compression Settings

### WebM/VP9
- **Codec:** libvpx-vp9
- **CRF:** 32 (Range: 0-63, higher = smaller file)
- **Deadline:** good (quality/speed balance)
- **Audio:** Removed (`-an`) - add `-c:a libopus -b:a 96k` if needed

## HTML Output

### Images (Automatic via includes)

```liquid
{% include image.html url="/assets/content/photo.png" description="Caption" %}
```

Generates:

```html
<picture>
  <source type="image/avif" srcset="
    /assets/content_compressed/photo-320w.avif 320w,
    /assets/content_compressed/photo-640w.avif 640w,
    /assets/content_compressed/photo-960w.avif 960w,
    /assets/content_compressed/photo-1280w.avif 1280w"
    sizes="(min-width: 768px) 800px, 100vw">
  
  <source type="image/webp" srcset="
    /assets/content_compressed/photo-fallback.webp">
  
  <img src="/assets/content_compressed/photo-640w.avif" 
       alt="Caption" 
       loading="lazy">
</picture>
```

**Browser Selection:**
- Chrome/Firefox/Edge → AVIF (smallest, best quality)
- Safari → WebP (good compression)
- Old browsers → AVIF fallback (still works)

### Videos

```liquid
{% include video.html url="/assets/content/video.mp4" ... %}
```

Path auto-updated to:
```html
<source src="/assets/content_compressed/video.webm" type="video/webm">
```

## Performance Impact

### Before (Original Media)
```
Typical post with 5 images + 1 video:
- Images: 5 × 2.5 MB = 12.5 MB
- Video: 1 × 45 MB = 45 MB
- Total: 57.5 MB
- Load time (3G): 3-5 minutes
- Lighthouse: 25-35/100
```

### After (Compressed)
```
Same post with compressed media:
- Images: 5 × 100 KB = 500 KB  (95% reduction)
- Video: 1 × 8 MB = 8 MB        (82% reduction)
- Total: 8.5 MB                 (85% reduction)
- Load time (3G): 15-25 seconds
- Lighthouse: 85-95/100
```

## Workflow for New Posts

1. Create post in `_posts/`
2. Add media to `assets/content/[project]/`
3. Reference in post: `/assets/content/[project]/image.png`
4. Run: `.\compress-media.ps1`
5. Build site: `bundle exec jekyll serve`
6. Verify: Check DevTools → Network tab

Media automatically uses compressed versions!

## Troubleshooting

### Compression fails
```powershell
# Check dependencies
magick -version
avifenc --help
ffmpeg -version

# Run with verbose output
.\compress-media.ps1 -Verbose
```

### Images not loading
- Ensure compression completed successfully
- Check browser console for 404 errors
- Verify file exists in `assets/content_compressed/`
- Check file extensions match (case-sensitive on Linux)

### Want to recompress
```powershell
# Recompress everything
.\compress-media.ps1 -Force

# Or delete output and rerun
Remove-Item assets\content_compressed -Recurse -Force
.\compress-media.ps1
```

### Rollback changes
```powershell
# Restore from backup
Copy-Item _backup\* . -Recurse -Force
```

## Advanced: Custom Settings

Edit `compress-media.ps1` to adjust:

```powershell
# Line 25-29: Configuration
$ImageSizes = @(320, 640, 960, 1280, 1920)  # Add 1920w for 4K
$AVIFQuality = 28                            # Better quality
$AVIFSpeed = 4                               # Slower, better compression
$VideoQuality = 28                           # Better video quality
```

## Browser Support

### AVIF
- ✅ Chrome 85+
- ✅ Firefox 93+
- ✅ Edge 92+
- ✅ Opera 71+
- ❌ Safari (uses WebP fallback)

### WebP
- ✅ All modern browsers
- ✅ Safari 14+
- ❌ IE 11 (uses AVIF as fallback - still works!)

### WebM/VP9
- ✅ Chrome, Firefox, Edge, Opera
- ⚠️ Safari (partial support)

## Maintenance

### Regular Tasks
- Run compression after adding new media
- Monitor `content_compressed/` size
- Clean up unused original files periodically

### Optimization Tips
- Use PNG for graphics/screenshots
- Use JPG for photos
- Aim for < 500 KB per image source
- Keep videos under 30 seconds if possible

## File Size Guidelines

### Good
- Image source: < 500 KB
- Video source: < 20 MB
- Compressed image: 50-150 KB
- Compressed video: 3-10 MB

### Acceptable
- Image source: < 1 MB
- Video source: < 50 MB
- Compressed image: 150-300 KB
- Compressed video: 10-20 MB

### Too Large (Needs Optimization)
- Image source: > 1 MB
- Video source: > 50 MB
- Compressed image: > 300 KB
- Compressed video: > 20 MB

## Success Metrics

✅ 80-95% file size reduction
✅ Lighthouse Performance: 85-95/100
✅ AVIF serving to 70%+ of users
✅ < 3 second load time on 4G
✅ < 30 seconds on 3G

Your site is now optimized for modern web performance! 🚀
