#!/usr/bin/env python3
"""
Simple skill packager - creates clean ZIP files for skill distribution.
The intelligence is in what QuickStart creates, not how it's packaged.

Usage:
    python package_skill.py <skill_path>
    python package_skill.py <skill_path> <output_dir>

Example:
    python package_skill.py /path/to/my-skill
    python package_skill.py /path/to/my-skill ./dist
"""

import zipfile
import sys
import os
from pathlib import Path


def package_skill(skill_path, output_dir=None):
    """
    Create a clean ZIP package of a skill.

    Args:
        skill_path: Path to the skill directory
        output_dir: Optional output directory (defaults to current)

    Returns:
        Path to created ZIP file, or None if error
    """
    skill_path = Path(skill_path).resolve()

    # Validate skill exists
    if not skill_path.exists():
        print(f"❌ Error: Skill directory not found: {skill_path}")
        return None

    if not skill_path.is_dir():
        print(f"❌ Error: Path is not a directory: {skill_path}")
        return None

    # Check for SKILL.md
    skill_md = skill_path / "SKILL.md"
    if not skill_md.exists():
        print(f"⚠️  Warning: SKILL.md not found in {skill_path}")
        response = input("Continue anyway? (y/n): ")
        if response.lower() != 'y':
            return None

    # Determine output location
    skill_name = skill_path.name
    if output_dir:
        output_path = Path(output_dir).resolve()
        output_path.mkdir(parents=True, exist_ok=True)
    else:
        output_path = Path.cwd()

    zip_filename = output_path / f"{skill_name}.zip"

    # Files/directories to exclude
    exclude_patterns = {
        '__pycache__',
        '.pyc',
        '.pyo',
        '.pyd',
        '.so',
        '.dll',
        '.DS_Store',
        'Thumbs.db',
        '.git',
        '.gitignore',
        '.env',
        '.venv',
        'env/',
        'venv/',
        '*.log',
        '*.bak',
        '*.swp',
        '*.tmp',
        '~*',
        '.idea/',
        '.vscode/',
        '*.egg-info/'
    }

    def should_exclude(file_path):
        """Check if a file should be excluded from the package."""
        path_str = str(file_path)
        name = file_path.name

        # Check exact matches and patterns
        for pattern in exclude_patterns:
            if pattern.endswith('/'):
                # Directory pattern
                if pattern[:-1] in path_str.split(os.sep):
                    return True
            elif pattern.startswith('*'):
                # Extension pattern
                if name.endswith(pattern[1:]):
                    return True
            elif pattern.endswith('*'):
                # Prefix pattern
                if name.startswith(pattern[:-1]):
                    return True
            elif pattern.startswith('.'):
                # Hidden file or extension
                if name == pattern or name.endswith(pattern):
                    return True
            else:
                # Exact match
                if pattern in path_str:
                    return True

        return False

    # Create the ZIP file
    try:
        file_count = 0
        with zipfile.ZipFile(zip_filename, 'w', zipfile.ZIP_DEFLATED) as zf:
            # Walk through the skill directory
            for file_path in skill_path.rglob('*'):
                if file_path.is_file() and not should_exclude(file_path):
                    # Calculate the archive name (relative path within ZIP)
                    arcname = Path(skill_name) / file_path.relative_to(skill_path)
                    zf.write(file_path, arcname)
                    file_count += 1
                    print(f"  Added: {arcname}")

        # Calculate package size
        size_bytes = zip_filename.stat().st_size
        if size_bytes < 1024:
            size_str = f"{size_bytes} bytes"
        elif size_bytes < 1024 * 1024:
            size_str = f"{size_bytes / 1024:.1f} KB"
        else:
            size_str = f"{size_bytes / (1024 * 1024):.1f} MB"

        print(f"\n✅ Successfully packaged {file_count} files")
        print(f"📦 Package created: {zip_filename}")
        print(f"📊 Package size: {size_str}")

        return zip_filename

    except Exception as e:
        print(f"❌ Error creating ZIP file: {e}")
        # Clean up partial ZIP if it exists
        if zip_filename.exists():
            zip_filename.unlink()
        return None


def main():
    """Main entry point for command-line usage."""
    if len(sys.argv) < 2:
        print("QuickStart Skill Packager")
        print("\nUsage:")
        print("  python package_skill.py <skill_path>")
        print("  python package_skill.py <skill_path> <output_dir>")
        print("\nExamples:")
        print("  python package_skill.py ./my-awesome-skill")
        print("  python package_skill.py ./my-awesome-skill ./dist")
        print("\nThis will create a clean ZIP file with your skill,")
        print("excluding unnecessary files like caches and temp files.")
        sys.exit(1)

    skill_path = sys.argv[1]
    output_dir = sys.argv[2] if len(sys.argv) > 2 else None

    print(f"📦 Packaging skill: {skill_path}")
    if output_dir:
        print(f"📁 Output directory: {output_dir}")
    print()

    result = package_skill(skill_path, output_dir)

    if result:
        print(f"\n🎉 Packaging complete!")
        print(f"You can now distribute: {result}")
        sys.exit(0)
    else:
        print(f"\n❌ Packaging failed")
        sys.exit(1)


if __name__ == "__main__":
    main()