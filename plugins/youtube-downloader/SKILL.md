---
name: youtube-downloader
description: Download videos from YouTube and 1000+ sites with quality presets, playlist/channel support, and batch processing
version: 1.0.0
allowed-tools:
  - Bash
  - Read
  - Write
  - AskUserQuestion
---

# YouTube Downloader

Download videos and audio from YouTube and 1000+ supported sites using yt-dlp. Supports single videos, playlists, channels, and batch downloads with quality presets and archive tracking.

## Triggers

Activate when user:
- Asks to download a YouTube video or audio
- Provides a video URL and wants to save it
- Says "download video", "save youtube", "grab video", "download playlist"
- Wants to extract audio from a video
- Needs to download multiple videos or a channel

## Arguments

```
$ARGUMENTS = <url|file> [options]

Input:
  <url>              Single video, playlist, or channel URL
  <file>             Path to text file with URLs (one per line)

Quality Presets:
  --quick            720p MP4 (fast, smaller files)
  --best             Best available quality (default)
  --4k               4K if available, else best
  --audio            Audio only as MP3 (192kbps)
  --audio=flac       Audio only as FLAC (lossless)

Options:
  --format=FORMAT    Video format: mp4, webm, mkv (default: mp4)
  --output=PATH      Output directory (default: current directory)
  --range=N-M        Playlist items range (e.g., 1-10, 5-, -20)
  --subs             Download subtitles (all available languages)
  --subs=LANG        Download specific subtitle language (e.g., en, es)
  --thumb            Download thumbnail
  --meta             Embed metadata in file
  --archive          Enable archive tracking (skip previously downloaded)
  --archive=FILE     Custom archive file path
  --proxy=URL        Use proxy for geo-restricted content
  --name=TEMPLATE    Custom filename template (yt-dlp syntax)

Integration:
  --transcript       Also extract transcript using youtube-transcriber skill
  --transcript=ts    Extract transcript with timestamps
```

## Workflow

### Phase 1: Setup & Validation

1. **Check/Install yt-dlp**
   ```bash
   if ! command -v yt-dlp &> /dev/null; then
       echo "Installing yt-dlp..."
       brew install yt-dlp 2>/dev/null || \
       sudo apt install -y yt-dlp 2>/dev/null || \
       pip install --user yt-dlp
   fi

   # Verify ffmpeg for format conversion
   if ! command -v ffmpeg &> /dev/null; then
       echo "Warning: ffmpeg not found. Some format conversions may fail."
       echo "Install with: brew install ffmpeg OR apt install ffmpeg"
   fi
   ```

2. **Parse input type**
   - Single URL: Validate format (youtube.com, youtu.be, vimeo.com, etc.)
   - File path: Check file exists, read URLs
   - Playlist/Channel: Detect from URL pattern

3. **Estimate download size** (for user consent on large downloads)
   ```bash
   # Get video info without downloading
   yt-dlp --dump-json --no-download "$URL" 2>/dev/null | \
       python3 -c "import sys,json; d=json.load(sys.stdin); print(f\"Title: {d.get('title')}\nDuration: {d.get('duration_string', 'Unknown')}\nSize: ~{d.get('filesize_approx', 0)//1048576}MB\")"
   ```

4. **User consent for large downloads**
   - If estimated size > 500MB or playlist > 10 items:
     - Show: title, duration, estimated size
     - Ask: "Proceed with download? [Yes/No]"

### Phase 2: Build yt-dlp Command

Construct command based on options:

#### Quality Presets

```bash
# --quick (720p)
FORMAT_QUICK="bestvideo[height<=720][ext=mp4]+bestaudio[ext=m4a]/best[height<=720][ext=mp4]/best"

# --best (default)
FORMAT_BEST="bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio/best"

# --4k
FORMAT_4K="bestvideo[height<=2160][ext=mp4]+bestaudio[ext=m4a]/bestvideo[height<=2160]+bestaudio/best"

# --audio (MP3)
FORMAT_AUDIO="-x --audio-format mp3 --audio-quality 192K"

# --audio=flac
FORMAT_AUDIO_FLAC="-x --audio-format flac"
```

#### Playlist/Channel Options

```bash
# Range filtering
--playlist-items "$RANGE"

# Archive tracking
--download-archive "$ARCHIVE_FILE"

# Skip unavailable videos
--ignore-errors
```

#### Output Template

```bash
# Default: VideoTitle.ext
--output "%(title)s.%(ext)s"

# With playlist index
--output "%(playlist_index)02d - %(title)s.%(ext)s"

# Custom template from --name
--output "$CUSTOM_TEMPLATE"
```

#### Additional Options

```bash
# Subtitles
--write-subs --sub-langs "$LANG"

# Thumbnails
--write-thumbnail

# Metadata embedding
--embed-metadata --embed-thumbnail

# Proxy
--proxy "$PROXY_URL"

# Progress
--progress --newline
```

### Phase 3: Execute Download

```bash
# Example full command
yt-dlp \
    --format "$FORMAT" \
    --output "$OUTPUT_DIR/%(title)s.%(ext)s" \
    --progress \
    --newline \
    --ignore-errors \
    --no-overwrites \
    $EXTRA_OPTIONS \
    "$URL"
```

**Progress reporting:**
- Show current file being downloaded
- Display progress percentage
- Report speed and ETA

### Phase 4: Post-Processing & Reporting

1. **Verify downloads**
   ```bash
   # List downloaded files
   ls -lh "$OUTPUT_DIR"/*.{mp4,mkv,webm,mp3,m4a,flac} 2>/dev/null
   ```

2. **Report results**
   ```
   ✓ Downloaded: "Video Title Here"
     Quality: 1080p (best)
     Format: MP4
     Size: 245 MB
     Location: /path/to/Video Title Here.mp4
   ```

3. **Batch/Playlist summary**
   ```
   Download Complete
   ─────────────────
   Total: 15 videos
   Success: 14
   Skipped: 1 (already in archive)

   Output: /path/to/output/
   Total size: 2.3 GB
   ```

### Phase 5: Transcript Extraction (if --transcript)

When `--transcript` flag is provided, invoke the `youtube-transcriber` skill after download:

1. **For each downloaded video URL:**
   ```
   Invoke youtube-transcriber with:
   - Same URL(s)
   - Same --output directory
   - --timestamps flag if --transcript=ts was used
   ```

2. **Transcript output:**
   - Saved alongside video file: `VideoTitle.txt`
   - Uses transcriber's 3-tier fallback (yt-dlp → Browser MCP → Whisper)

3. **Combined report:**
   ```
   ✓ Downloaded: "Video Title Here"
     Video: /path/to/Video Title Here.mp4 (245 MB)
     Transcript: /path/to/Video Title Here.txt (42 KB, 1,247 lines)
   ```

## Examples

### Simple Downloads

```bash
# Best quality (default)
youtube-downloader https://youtube.com/watch?v=abc123

# Quick 720p
youtube-downloader https://youtube.com/watch?v=abc123 --quick

# 4K quality
youtube-downloader https://youtube.com/watch?v=abc123 --4k

# Audio only
youtube-downloader https://youtube.com/watch?v=abc123 --audio
```

### Playlist Downloads

```bash
# Full playlist
youtube-downloader https://youtube.com/playlist?list=PLxyz

# First 10 videos only
youtube-downloader https://youtube.com/playlist?list=PLxyz --range=1-10

# With archive tracking
youtube-downloader https://youtube.com/playlist?list=PLxyz --archive
```

### Channel Downloads

```bash
# Download channel videos
youtube-downloader https://youtube.com/@ChannelName/videos --range=1-20

# Audio podcast extraction from channel
youtube-downloader https://youtube.com/@PodcastChannel --audio --archive
```

### Batch Downloads

```bash
# From URL file
youtube-downloader ./urls.txt --output=./downloads/

# With subtitles and thumbnails
youtube-downloader ./urls.txt --subs=en --thumb --meta
```

### Download + Transcript

```bash
# Download video and extract transcript
youtube-downloader https://youtube.com/watch?v=abc123 --transcript

# Download with timestamped transcript
youtube-downloader https://youtube.com/watch?v=abc123 --transcript=ts

# Playlist with transcripts
youtube-downloader https://youtube.com/playlist?list=PLxyz --range=1-5 --transcript

# Audio + transcript (podcast archival)
youtube-downloader https://youtube.com/@PodcastChannel --audio --transcript --archive
```

### Advanced Options

```bash
# Custom output template
youtube-downloader $URL --name="%(upload_date)s - %(title)s.%(ext)s"

# With proxy for geo-restricted
youtube-downloader $URL --proxy=socks5://127.0.0.1:1080

# Lossless audio
youtube-downloader $URL --audio=flac
```

## Supported Sites

This skill uses yt-dlp which supports 1000+ sites including:
- YouTube (videos, playlists, channels, shorts, live)
- Vimeo
- TikTok
- Instagram (posts, reels, stories)
- Twitter/X
- Twitch (clips, VODs)
- Reddit
- Facebook
- SoundCloud
- Bandcamp
- And many more...

Run `yt-dlp --list-extractors` for full list.

## Error Handling

| Error | Action |
|-------|--------|
| Video unavailable | Skip with warning, continue batch |
| Private/members-only | Notify user, suggest login cookies |
| Age-restricted | Try with cookies or notify user |
| Geo-restricted | Suggest --proxy option |
| Format unavailable | Fall back to best available |
| Network timeout | Retry up to 3 times |
| Disk space low | Warn before download, ask to proceed |

## Notes

- **Copyright**: Only download content you have rights to access
- **Terms of Service**: Respect platform ToS
- **Storage**: 4K videos can be 1-2GB+ per hour
- **Bandwidth**: Large downloads may take significant time
- **Cookies**: For authenticated content, use browser cookies with `--cookies-from-browser chrome`

## See Also

- **youtube-transcriber** - Extract transcripts only (without downloading video). Uses 3-tier fallback: yt-dlp subtitles → Browser MCP → Whisper AI. Invoked automatically when using `--transcript` flag.
