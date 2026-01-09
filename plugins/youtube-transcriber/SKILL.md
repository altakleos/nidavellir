---
name: youtube-transcriber
description: Extract transcripts from YouTube videos with intelligent 3-tier fallback (yt-dlp → Browser MCP → Whisper AI) and batch support
version: 1.0.0
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
  - Task
  - AskUserQuestion
---

# YouTube Transcriber

Extract transcripts from YouTube videos using a robust 3-tier fallback system. Supports batch processing, multiple output formats, and automatic deduplication.

## Triggers

Activate when user:
- Provides YouTube URL(s) and asks for transcript/subtitles/captions
- Says "transcribe this video", "get youtube transcript", "extract subtitles"
- Wants to convert YouTube video to text

## Arguments

```
$ARGUMENTS = <url(s)> [options]

Options:
  --timestamps    Include timestamps in output (default: plain text)
  --lang=XX       Language code priority (default: en)
  --output=PATH   Custom output location
  --format=FORMAT Output format: txt, vtt, srt (default: txt)
```

## Workflow

### Phase 1: Input Validation & Setup

1. **Parse input URLs**
   ```bash
   # Accept multiple formats:
   # - Space-separated URLs
   # - File with URLs (one per line, if path provided)
   # - Single URL
   ```

2. **Validate each URL**
   - Must match: `youtube.com/watch?v=`, `youtu.be/`, `youtube.com/shorts/`
   - Extract video ID for each

3. **Determine output location**
   - If `--output` specified: use that path
   - If in a project with `docs/` or `transcripts/` folder: suggest that
   - If working directory is writable: use current directory
   - Otherwise: ASK user with AskUserQuestion tool

4. **Auto-install dependencies**
   ```bash
   # Install yt-dlp if missing (required for Tier 1 & 3)
   if ! command -v yt-dlp &> /dev/null; then
       echo "Installing yt-dlp..."
       if command -v brew &> /dev/null; then
           brew install yt-dlp
       elif command -v apt &> /dev/null; then
           sudo apt update && sudo apt install -y yt-dlp
       elif command -v pacman &> /dev/null; then
           sudo pacman -S yt-dlp
       else
           pip install --user yt-dlp
       fi
   fi

   # Install ffmpeg if missing (required for Whisper audio extraction)
   if ! command -v ffmpeg &> /dev/null; then
       echo "Installing ffmpeg..."
       if command -v brew &> /dev/null; then
           brew install ffmpeg
       elif command -v apt &> /dev/null; then
           sudo apt update && sudo apt install -y ffmpeg
       elif command -v pacman &> /dev/null; then
           sudo pacman -S ffmpeg
       else
           echo "Please install ffmpeg manually: https://ffmpeg.org/download.html"
       fi
   fi

   # Verify installations
   echo "Dependencies:"
   yt-dlp --version && echo "  yt-dlp: ✓" || echo "  yt-dlp: ✗ MISSING"
   ffmpeg -version 2>/dev/null | head -1 && echo "  ffmpeg: ✓" || echo "  ffmpeg: ✗ MISSING (needed for Whisper)"

   # Note: Whisper is installed on-demand in Tier 3 (with user consent)
   # Note: Browser MCP availability is checked in Tier 2
   ```

### Phase 2: Extraction (3-Tier Fallback)

For each URL, attempt extraction in order:

#### Tier 1: yt-dlp with Cookie Support (Fastest)

```bash
# List available subtitles first
yt-dlp --list-subs "$VIDEO_URL" 2>&1

# Download with cookie support and language priority
yt-dlp \
    --cookies-from-browser chrome \
    --write-sub \
    --write-auto-sub \
    --sub-lang "en,en-US,en-GB" \
    --sub-format "vtt/srt/best" \
    --skip-download \
    --output "%(title)s.%(ext)s" \
    "$VIDEO_URL"
```

**If Tier 1 fails** (exit code ≠ 0, or no subtitles found): proceed to Tier 2

#### Tier 2: Browser Automation via MCP

Only attempt if `chrome-devtools-mcp` or similar browser MCP is available.

```
1. Open video URL in browser
2. Wait for page load
3. Click "...more" to expand description
4. Locate and click "Show transcript" button
5. Extract transcript segments from DOM:
   - Query: ytd-transcript-segment-renderer
   - Extract: timestamp + text pairs
6. Save to file
7. Close browser session
```

**If Tier 2 fails or MCP unavailable**: proceed to Tier 3

#### Tier 3: Whisper AI Transcription (Last Resort)

⚠️ **REQUIRES USER CONSENT** - This downloads audio files.

```
1. STOP and inform user:
   "No subtitles available for this video.
    I can transcribe the audio using Whisper AI.

    This requires:
    - Downloading audio (~X MB estimated)
    - Whisper model (~1-3GB if not installed)
    - Processing time: ~Y minutes

    Proceed? [Yes/No]"

2. If user consents:
   ```bash
   # Download audio only
   yt-dlp -x --audio-format mp3 -o "%(title)s.%(ext)s" "$VIDEO_URL"

   # Auto-install Whisper if missing
   if ! command -v whisper &> /dev/null; then
       echo "Installing OpenAI Whisper..."
       pip install --user openai-whisper
       # Whisper requires ffmpeg (already installed in Phase 1)
   fi

   # Transcribe with base model (good balance of speed/accuracy)
   whisper "$AUDIO_FILE" --model base --output_format txt --output_dir .

   # Clean up audio file (ask first)
   "Delete temporary audio file? [Yes/No]"
   ```

### Phase 3: Post-Processing

#### Deduplication (Critical for auto-generated captions)

Auto-generated YouTube captions contain progressive duplicates. Run this Python script:

```python
#!/usr/bin/env python3
"""
Deduplicate YouTube VTT/SRT captions.
Removes progressive caption artifacts where text builds up character by character.
"""
import re
import sys
from html import unescape

def clean_line(line):
    """Strip HTML tags and normalize whitespace."""
    line = re.sub(r'<[^>]+>', '', line)  # Remove HTML tags
    line = unescape(line)                  # Convert HTML entities
    line = re.sub(r'\s+', ' ', line)       # Normalize whitespace
    return line.strip()

def deduplicate(content):
    """Remove duplicate lines while preserving order."""
    seen = set()
    result = []

    for line in content.split('\n'):
        cleaned = clean_line(line)
        if cleaned and cleaned not in seen:
            seen.add(cleaned)
            result.append(cleaned)

    return '\n'.join(result)

if __name__ == '__main__':
    input_file = sys.argv[1]
    with open(input_file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Remove VTT/SRT metadata
    content = re.sub(r'WEBVTT\n.*?\n\n', '', content, flags=re.DOTALL)
    content = re.sub(r'\d+\n\d{2}:\d{2}:\d{2}[.,]\d{3} --> \d{2}:\d{2}:\d{2}[.,]\d{3}\n', '', content)

    print(deduplicate(content))
```

#### Format Conversion

Based on `--timestamps` flag and `--format`:

- **Plain text** (default): Strip all timestamps, just content
- **Timestamped**: `[HH:MM:SS] Text content`
- **VTT/SRT**: Keep original subtitle format

### Phase 4: Output & Reporting

For each processed video, report:

```
✓ Video: "Video Title Here"
  Source: yt-dlp (Tier 1) | Browser MCP (Tier 2) | Whisper (Tier 3)
  Language: en (auto-generated)
  Output: /path/to/Video Title Here.txt
  Lines: 342 (deduplicated from 1,247)
```

**Batch summary** (if multiple URLs):
```
Completed: 5/5 videos
  - Tier 1 (yt-dlp): 3
  - Tier 2 (Browser): 1
  - Tier 3 (Whisper): 1
Total output: 5 files in /path/to/output/
```

## Error Handling

| Error | Action |
|-------|--------|
| Invalid URL | Skip with warning, continue batch |
| Private video | Notify user, suggest browser method with login |
| Age-restricted | Try browser method with logged-in session |
| No subtitles + no Whisper consent | Skip with clear message |
| Network timeout | Retry once, then fail gracefully |
| yt-dlp SSL error | Try with `--no-check-certificate` flag |

## Examples

**Single video, plain text:**
```
youtube-transcriber https://youtube.com/watch?v=abc123
```

**Multiple videos with timestamps:**
```
youtube-transcriber https://youtu.be/abc https://youtu.be/xyz --timestamps
```

**Custom output and language:**
```
youtube-transcriber https://youtube.com/watch?v=abc --lang=es --output=./transcripts/
```

**From file list:**
```
youtube-transcriber ./video-urls.txt --format=srt
```

## See Also

- **youtube-downloader** - Download videos/audio from YouTube and 1000+ sites. Use `--transcript` flag to automatically extract transcripts after download.
