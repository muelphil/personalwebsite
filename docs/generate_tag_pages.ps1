# Generate Tag Pages for Jekyll Blog
# This script scans all posts for tags and creates tag filter pages

$postsDir = "C:\Users\PHMU3\IdeaProjects\personalwebsite\docs\_posts"
$blogDir = "C:\Users\PHMU3\IdeaProjects\personalwebsite\docs\blog"

# Ensure blog directory exists
if (-not (Test-Path $blogDir)) {
    New-Item -Path $blogDir -ItemType Directory -Force | Out-Null
}

# Collect all unique tags
$tags = @()
Get-ChildItem $postsDir -Filter "*.m*" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match 'tags:\s*\[(.*?)\]') {
        $tagList = $matches[1] -split ',' | ForEach-Object { $_.Trim().Trim('"') }
        $tags += $tagList
    }
}

$uniqueTags = $tags | Select-Object -Unique | Sort-Object

Write-Host "Found tags: $($uniqueTags -join ', ')"

# Generate a page for each tag
foreach ($tag in $uniqueTags) {
    $tagSlug = $tag -replace ' ', '_'
    $filename = "$blogDir\$tagSlug.markdown"
    
    $content = @"
---
layout: blog
tag: $tag
title: Blog - $tag
permalink: /blog/$tagSlug/
---
"@
    
    Set-Content -Path $filename -Value $content
    Write-Host "Created: $filename"
}

Write-Host "`nTag pages generated successfully!"
Write-Host "Total tags: $($uniqueTags.Count)"
