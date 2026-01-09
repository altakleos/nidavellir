#!/usr/bin/env python3
"""
YouTube Caption Deduplicator

Removes progressive caption artifacts from auto-generated YouTube subtitles.
Auto-generated captions often repeat text as it builds up character by character,
resulting in many duplicate or near-duplicate lines.

Usage:
    python dedupe.py input.vtt > output.txt
    python dedupe.py input.vtt --timestamps > output.txt
    python dedupe.py input.vtt --format=srt > output.srt
"""

import re
import sys
import argparse
from html import unescape
from pathlib import Path


def clean_line(line: str) -> str:
    """Strip HTML tags, convert entities, and normalize whitespace."""
    # Remove HTML tags (e.g., <font color="#...">)
    line = re.sub(r'<[^>]+>', '', line)
    # Convert HTML entities
    line = unescape(line)
    # Normalize whitespace
    line = re.sub(r'\s+', ' ', line)
    return line.strip()


def parse_vtt_timestamp(timestamp: str) -> str:
    """Convert VTT timestamp to simple HH:MM:SS format."""
    match = re.match(r'(\d{2}):(\d{2}):(\d{2})[.,]\d{3}', timestamp)
    if match:
        return f"{match.group(1)}:{match.group(2)}:{match.group(3)}"
    # Handle MM:SS format
    match = re.match(r'(\d{2}):(\d{2})[.,]\d{3}', timestamp)
    if match:
        return f"00:{match.group(1)}:{match.group(2)}"
    return timestamp


def parse_vtt(content: str) -> list[tuple[str, str]]:
    """Parse VTT content into (timestamp, text) pairs."""
    # Remove WEBVTT header and metadata
    content = re.sub(r'WEBVTT\n.*?\n\n', '', content, flags=re.DOTALL)
    content = re.sub(r'Kind:.*\n', '', content)
    content = re.sub(r'Language:.*\n', '', content)

    segments = []
    # Match timestamp lines and following text
    pattern = r'(\d{2}:\d{2}[:\d{2}]?[.,]\d{3})\s*-->\s*(\d{2}:\d{2}[:\d{2}]?[.,]\d{3})\n(.+?)(?=\n\n|\n\d{2}:\d{2}|\Z)'

    for match in re.finditer(pattern, content, re.DOTALL):
        start_time = parse_vtt_timestamp(match.group(1))
        text = clean_line(match.group(3))
        if text:
            segments.append((start_time, text))

    return segments


def parse_srt(content: str) -> list[tuple[str, str]]:
    """Parse SRT content into (timestamp, text) pairs."""
    segments = []
    # SRT format: index\ntimestamp --> timestamp\ntext\n\n
    pattern = r'\d+\n(\d{2}:\d{2}:\d{2}),\d{3}\s*-->\s*\d{2}:\d{2}:\d{2},\d{3}\n(.+?)(?=\n\n|\Z)'

    for match in re.finditer(pattern, content, re.DOTALL):
        timestamp = match.group(1)
        text = clean_line(match.group(2))
        if text:
            segments.append((timestamp, text))

    return segments


def deduplicate(segments: list[tuple[str, str]]) -> list[tuple[str, str]]:
    """Remove duplicate text while preserving order and timestamps."""
    seen = set()
    result = []

    for timestamp, text in segments:
        # Normalize for comparison
        normalized = text.lower().strip()

        # Skip if we've seen this exact text
        if normalized in seen:
            continue

        # Skip if this text is a substring of the previous entry
        # (handles progressive caption buildup)
        if result and normalized in result[-1][1].lower():
            continue

        # Skip if previous text is a substring of this
        # (replace with the longer version)
        if result and result[-1][1].lower() in normalized:
            seen.discard(result[-1][1].lower().strip())
            result.pop()

        seen.add(normalized)
        result.append((timestamp, text))

    return result


def format_output(segments: list[tuple[str, str]],
                  include_timestamps: bool = False,
                  output_format: str = 'txt') -> str:
    """Format segments into the desired output format."""

    if output_format == 'txt':
        if include_timestamps:
            return '\n'.join(f'[{ts}] {text}' for ts, text in segments)
        else:
            return '\n'.join(text for _, text in segments)

    elif output_format == 'srt':
        lines = []
        for i, (ts, text) in enumerate(segments, 1):
            # Convert to SRT timestamp format
            start = ts.replace('.', ',') + ',000'
            # Estimate end time (add 3 seconds)
            parts = ts.split(':')
            end_sec = int(parts[-1]) + 3
            end = f"{parts[0]}:{parts[1]}:{end_sec:02d},000"
            lines.append(f"{i}\n{start} --> {end}\n{text}\n")
        return '\n'.join(lines)

    elif output_format == 'vtt':
        lines = ['WEBVTT\n']
        for ts, text in segments:
            start = ts + '.000'
            # Estimate end time
            parts = ts.split(':')
            end_sec = int(parts[-1]) + 3
            end = f"{parts[0]}:{parts[1]}:{end_sec:02d}.000"
            lines.append(f"{start} --> {end}\n{text}\n")
        return '\n'.join(lines)

    return '\n'.join(text for _, text in segments)


def main():
    parser = argparse.ArgumentParser(
        description='Deduplicate YouTube caption files'
    )
    parser.add_argument('input', help='Input VTT/SRT file')
    parser.add_argument('--timestamps', '-t', action='store_true',
                        help='Include timestamps in output')
    parser.add_argument('--format', '-f', choices=['txt', 'srt', 'vtt'],
                        default='txt', help='Output format (default: txt)')
    parser.add_argument('--stats', '-s', action='store_true',
                        help='Print statistics to stderr')

    args = parser.parse_args()

    # Read input file
    input_path = Path(args.input)
    content = input_path.read_text(encoding='utf-8')

    # Detect format and parse
    if input_path.suffix.lower() == '.srt':
        segments = parse_srt(content)
    else:
        segments = parse_vtt(content)

    original_count = len(segments)

    # Deduplicate
    segments = deduplicate(segments)

    # Format and output
    output = format_output(segments, args.timestamps, args.format)
    print(output)

    # Print stats if requested
    if args.stats:
        print(f"\n--- Stats ---", file=sys.stderr)
        print(f"Original lines: {original_count}", file=sys.stderr)
        print(f"After dedup: {len(segments)}", file=sys.stderr)
        print(f"Removed: {original_count - len(segments)} ({100*(original_count-len(segments))/max(original_count,1):.1f}%)", file=sys.stderr)


if __name__ == '__main__':
    main()
