#!/usr/bin/env python3
"""
YouTube Downloader Script

A wrapper around yt-dlp for consistent, scriptable video downloads.
Supports quality presets, playlists, channels, and batch operations.

Usage:
    python download.py <url> [options]
    python download.py --file urls.txt [options]

Examples:
    python download.py "https://youtube.com/watch?v=abc" --quick
    python download.py "https://youtube.com/playlist?list=xyz" --range 1-10
    python download.py --file urls.txt --audio --output ./music/
"""

import argparse
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path


# Quality format presets
QUALITY_PRESETS = {
    "quick": "bestvideo[height<=720][ext=mp4]+bestaudio[ext=m4a]/best[height<=720][ext=mp4]/best",
    "best": "bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio/best",
    "4k": "bestvideo[height<=2160][ext=mp4]+bestaudio[ext=m4a]/bestvideo[height<=2160]+bestaudio/best",
    "1080p": "bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[height<=1080]/best",
    "720p": "bestvideo[height<=720][ext=mp4]+bestaudio[ext=m4a]/best[height<=720]/best",
    "480p": "bestvideo[height<=480][ext=mp4]+bestaudio[ext=m4a]/best[height<=480]/best",
}

AUDIO_FORMATS = ["mp3", "m4a", "flac", "wav", "opus"]


def check_dependencies():
    """Check if required tools are installed."""
    if not shutil.which("yt-dlp"):
        print("Error: yt-dlp not found. Install with:")
        print("  brew install yt-dlp  OR")
        print("  apt install yt-dlp   OR")
        print("  pip install yt-dlp")
        sys.exit(1)

    if not shutil.which("ffmpeg"):
        print("Warning: ffmpeg not found. Some format conversions may fail.")
        print("Install with: brew install ffmpeg OR apt install ffmpeg")


def get_video_info(url: str) -> dict:
    """Fetch video metadata without downloading."""
    try:
        result = subprocess.run(
            ["yt-dlp", "--dump-json", "--no-download", url],
            capture_output=True,
            text=True,
            timeout=30
        )
        if result.returncode == 0:
            return json.loads(result.stdout)
    except (subprocess.TimeoutExpired, json.JSONDecodeError):
        pass
    return {}


def format_size(bytes_size: int) -> str:
    """Format bytes to human-readable size."""
    if not bytes_size:
        return "Unknown"
    for unit in ["B", "KB", "MB", "GB"]:
        if bytes_size < 1024:
            return f"{bytes_size:.1f} {unit}"
        bytes_size /= 1024
    return f"{bytes_size:.1f} TB"


def build_command(args) -> list:
    """Build yt-dlp command from arguments."""
    cmd = ["yt-dlp"]

    # Quality/format selection
    if args.audio:
        audio_format = args.audio if args.audio in AUDIO_FORMATS else "mp3"
        cmd.extend(["-x", "--audio-format", audio_format])
        if audio_format == "mp3":
            cmd.extend(["--audio-quality", "192K"])
    else:
        quality = args.quality or "best"
        if quality in QUALITY_PRESETS:
            cmd.extend(["-f", QUALITY_PRESETS[quality]])

        # Container format
        if args.format:
            cmd.extend(["--merge-output-format", args.format])

    # Output template
    output_dir = Path(args.output).resolve() if args.output else Path.cwd()
    output_dir.mkdir(parents=True, exist_ok=True)

    if args.name:
        template = args.name
    elif args.playlist or args.channel:
        template = "%(playlist_index)02d - %(title)s.%(ext)s"
    else:
        template = "%(title)s.%(ext)s"

    cmd.extend(["-o", str(output_dir / template)])

    # Playlist options
    if args.range:
        cmd.extend(["--playlist-items", args.range])

    # Archive tracking
    if args.archive:
        archive_file = args.archive if isinstance(args.archive, str) else str(output_dir / ".download-archive.txt")
        cmd.extend(["--download-archive", archive_file])

    # Subtitles
    if args.subs:
        cmd.append("--write-subs")
        if args.subs != True:  # Specific language
            cmd.extend(["--sub-langs", args.subs])

    # Thumbnail
    if args.thumb:
        cmd.append("--write-thumbnail")

    # Metadata
    if args.meta:
        cmd.extend(["--embed-metadata", "--embed-thumbnail"])

    # Proxy
    if args.proxy:
        cmd.extend(["--proxy", args.proxy])

    # Common options
    cmd.extend([
        "--progress",
        "--newline",
        "--ignore-errors",
        "--no-overwrites",
        "--restrict-filenames",
    ])

    return cmd


def download_url(url: str, cmd: list, show_info: bool = True):
    """Download a single URL."""
    if show_info:
        info = get_video_info(url)
        if info:
            title = info.get("title", "Unknown")
            duration = info.get("duration_string", "Unknown")
            size = format_size(info.get("filesize_approx", 0))
            print(f"\n📹 {title}")
            print(f"   Duration: {duration} | Est. size: {size}")

    full_cmd = cmd + [url]

    try:
        process = subprocess.Popen(
            full_cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            bufsize=1
        )

        for line in process.stdout:
            print(line, end="")

        process.wait()
        return process.returncode == 0

    except KeyboardInterrupt:
        print("\n\nDownload cancelled by user.")
        process.terminate()
        return False


def main():
    parser = argparse.ArgumentParser(
        description="Download videos from YouTube and 1000+ sites"
    )

    # Input
    parser.add_argument("url", nargs="?", help="Video/playlist/channel URL")
    parser.add_argument("--file", "-f", help="File with URLs (one per line)")

    # Quality presets
    quality_group = parser.add_mutually_exclusive_group()
    quality_group.add_argument("--quick", action="store_const", const="quick", dest="quality",
                               help="720p MP4 (fast, smaller)")
    quality_group.add_argument("--best", action="store_const", const="best", dest="quality",
                               help="Best available quality (default)")
    quality_group.add_argument("--4k", action="store_const", const="4k", dest="quality",
                               help="4K if available")
    quality_group.add_argument("--1080p", action="store_const", const="1080p", dest="quality")
    quality_group.add_argument("--720p", action="store_const", const="720p", dest="quality")
    quality_group.add_argument("--480p", action="store_const", const="480p", dest="quality")

    # Audio
    parser.add_argument("--audio", "-a", nargs="?", const="mp3",
                        help="Audio only (mp3, m4a, flac, wav, opus)")

    # Format
    parser.add_argument("--format", choices=["mp4", "webm", "mkv"],
                        help="Video container format")

    # Output
    parser.add_argument("--output", "-o", help="Output directory")
    parser.add_argument("--name", help="Custom filename template (yt-dlp syntax)")

    # Playlist/channel
    parser.add_argument("--range", "-r", help="Playlist items range (e.g., 1-10)")
    parser.add_argument("--playlist", action="store_true", help="Treat URL as playlist")
    parser.add_argument("--channel", action="store_true", help="Treat URL as channel")

    # Archive
    parser.add_argument("--archive", nargs="?", const=True,
                        help="Enable archive tracking (optional: custom file path)")

    # Extras
    parser.add_argument("--subs", nargs="?", const=True,
                        help="Download subtitles (optional: language code)")
    parser.add_argument("--thumb", action="store_true", help="Download thumbnail")
    parser.add_argument("--meta", action="store_true", help="Embed metadata")
    parser.add_argument("--proxy", help="Proxy URL for geo-restricted content")

    # Info only
    parser.add_argument("--info", action="store_true", help="Show info without downloading")

    args = parser.parse_args()

    # Validate input
    if not args.url and not args.file:
        parser.error("Please provide a URL or --file with URLs")

    check_dependencies()

    # Build base command
    cmd = build_command(args)

    # Process URLs
    urls = []
    if args.file:
        file_path = Path(args.file)
        if not file_path.exists():
            print(f"Error: File not found: {args.file}")
            sys.exit(1)
        urls = [line.strip() for line in file_path.read_text().splitlines() if line.strip() and not line.startswith("#")]
    elif args.url:
        urls = [args.url]

    if not urls:
        print("No URLs to process.")
        sys.exit(0)

    # Info only mode
    if args.info:
        for url in urls:
            info = get_video_info(url)
            if info:
                print(f"\nTitle: {info.get('title', 'Unknown')}")
                print(f"Duration: {info.get('duration_string', 'Unknown')}")
                print(f"Uploader: {info.get('uploader', 'Unknown')}")
                print(f"Est. size: {format_size(info.get('filesize_approx', 0))}")
                print(f"URL: {url}")
        sys.exit(0)

    # Download
    print(f"\n{'='*50}")
    print(f"YouTube Downloader")
    print(f"{'='*50}")
    print(f"URLs to process: {len(urls)}")
    print(f"Quality: {args.quality or 'best'}")
    print(f"Output: {args.output or 'current directory'}")
    print(f"{'='*50}")

    success = 0
    failed = 0

    for i, url in enumerate(urls, 1):
        print(f"\n[{i}/{len(urls)}] Processing...")
        if download_url(url, cmd, show_info=True):
            success += 1
            print("✓ Complete")
        else:
            failed += 1
            print("✗ Failed")

    # Summary
    print(f"\n{'='*50}")
    print(f"Download Summary")
    print(f"{'='*50}")
    print(f"Success: {success}")
    print(f"Failed: {failed}")
    print(f"Output: {args.output or Path.cwd()}")
    print(f"{'='*50}\n")


if __name__ == "__main__":
    main()
