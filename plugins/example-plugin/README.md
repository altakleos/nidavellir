# Example Plugin

This is an example plugin that demonstrates the structure and best practices for creating Claude Code plugins.

## What's Included

This plugin includes:

- **Commands**: Example slash command (`/hello`)
- **Skills**: Example skill for demonstration
- **Documentation**: This README

## Installation

```bash
/plugin install example-plugin@altakleos
```

## Usage

### Commands

#### `/hello [name]`

Greets the user with a friendly message.

**Example**:
```bash
/hello World
# Output: Hello, World! This is an example plugin.
```

### Skills

The example skill demonstrates how to structure skills for Claude Code.

## Development

This plugin serves as a template for creating your own plugins. Feel free to copy and modify it for your needs.

## Structure

```
example-plugin/
├── plugin.json          # Plugin metadata
├── README.md            # This file
└── .claude/
    ├── commands/        # Slash commands
    │   └── hello.md
    └── skills/          # Skills
        └── example.md
```

## License

MIT
