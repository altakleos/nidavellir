---
name: mcp-patterns
type: reference
description: Common MCP integration patterns and best practices for Claude Code
---

# MCP Integration Patterns Reference

This guide documents common patterns for integrating MCP (Model Context Protocol) servers with Claude Code extensions.

## Overview

MCP is becoming the universal standard for connecting AI agents to external tools. This reference covers patterns for database access, API integration, custom tools, and security.

## Available MCP Server Packages

### Official Anthropic Servers

| Package | Purpose | Install |
|---------|---------|---------|
| `@modelcontextprotocol/server-postgres` | PostgreSQL database | `npx -y @modelcontextprotocol/server-postgres` |
| `@modelcontextprotocol/server-sqlite` | SQLite database | `npx -y @modelcontextprotocol/server-sqlite` |
| `@modelcontextprotocol/server-github` | GitHub API | `npx -y @modelcontextprotocol/server-github` |
| `@modelcontextprotocol/server-slack` | Slack API | `npx -y @modelcontextprotocol/server-slack` |
| `@modelcontextprotocol/server-filesystem` | Extended file operations | `npx -y @modelcontextprotocol/server-filesystem` |
| `@modelcontextprotocol/server-gdrive` | Google Drive | `npx -y @modelcontextprotocol/server-gdrive` |
| `@modelcontextprotocol/server-memory` | Persistent memory | `npx -y @modelcontextprotocol/server-memory` |

### Community Servers

| Package | Purpose | Source |
|---------|---------|--------|
| `mcp-server-redis` | Redis database | npm |
| `mcp-server-mongodb` | MongoDB database | npm |
| `mcp-server-linear` | Linear issue tracking | npm |
| `mcp-server-notion` | Notion workspace | npm |
| `mcp-server-jira` | Jira issue tracking | npm |

---

## Pattern 1: Database Access

### When to Use

- Querying project databases
- Generating reports from data
- Managing application state
- Data migration tasks

### PostgreSQL Pattern

```json
{
  "mcpServers": {
    "project-db": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "${DATABASE_URL}"
      }
    }
  }
}
```

**Usage in Skill/Agent:**

```markdown
## Database Queries

Use the `mcp__project-db` tool to query the database:

- `mcp__project-db.query()` - Execute SQL query
- `mcp__project-db.list_tables()` - List available tables
- `mcp__project-db.describe_table()` - Get table schema
```

### SQLite Pattern (Local Database)

```json
{
  "mcpServers": {
    "local-db": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-sqlite",
        "--db-path",
        "./data/app.db"
      ]
    }
  }
}
```

### Multi-Database Pattern

```json
{
  "mcpServers": {
    "analytics": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "${ANALYTICS_DB_URL}"
      }
    },
    "cache": {
      "command": "npx",
      "args": ["-y", "mcp-server-redis"],
      "env": {
        "REDIS_URL": "${REDIS_URL}"
      }
    }
  }
}
```

---

## Pattern 2: API Integration

### When to Use

- Integrating with external services
- Automating workflows across platforms
- Fetching real-time data
- Managing project resources

### GitHub Pattern

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

**Available Tools:**
- `mcp__github.get_repo()` - Get repository info
- `mcp__github.list_issues()` - List issues
- `mcp__github.create_issue()` - Create new issue
- `mcp__github.get_pull_request()` - Get PR details
- `mcp__github.create_pull_request()` - Create PR

### Slack Pattern

```json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}",
        "SLACK_TEAM_ID": "${SLACK_TEAM_ID}"
      }
    }
  }
}
```

**Available Tools:**
- `mcp__slack.post_message()` - Send message to channel
- `mcp__slack.list_channels()` - List available channels
- `mcp__slack.get_channel_history()` - Get recent messages

### Multi-Service DevOps Pattern

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {"GITHUB_TOKEN": "${GITHUB_TOKEN}"}
    },
    "linear": {
      "command": "npx",
      "args": ["-y", "mcp-server-linear"],
      "env": {"LINEAR_API_KEY": "${LINEAR_API_KEY}"}
    },
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}",
        "SLACK_TEAM_ID": "${SLACK_TEAM_ID}"
      }
    }
  }
}
```

---

## Pattern 3: File System Extensions

### When to Use

- Accessing cloud storage
- Working with restricted directories
- Extended file operations
- Network drive access

### Read-Only Filesystem Pattern

```json
{
  "mcpServers": {
    "docs": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "--root", "./docs",
        "--read-only"
      ]
    }
  }
}
```

### Google Drive Pattern

```json
{
  "mcpServers": {
    "gdrive": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-gdrive"],
      "env": {
        "GOOGLE_APPLICATION_CREDENTIALS": "${GOOGLE_CREDS_PATH}"
      }
    }
  }
}
```

---

## Pattern 4: Custom Tool Servers

### When to Use

- Domain-specific business logic
- Proprietary system integration
- Complex multi-step operations
- Specialized data processing

### Python Custom Server Pattern

**Configuration:**
```json
{
  "mcpServers": {
    "custom-tools": {
      "command": "python3",
      "args": ["./mcp-servers/custom-tools.py"],
      "cwd": "${workspaceFolder}"
    }
  }
}
```

**Server Implementation:**
```python
#!/usr/bin/env python3
import asyncio
import json
import sys

class CustomMCPServer:
    def __init__(self):
        self.tools = {
            "domain_operation": {
                "name": "domain_operation",
                "description": "Performs domain-specific operation",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "input_data": {"type": "string"}
                    },
                    "required": ["input_data"]
                }
            }
        }

    async def handle(self, request):
        method = request.get("method")

        if method == "tools/list":
            return {"tools": list(self.tools.values())}

        elif method == "tools/call":
            name = request["params"]["name"]
            args = request["params"].get("arguments", {})

            if name == "domain_operation":
                result = self.domain_operation(args["input_data"])
                return {"content": [{"type": "text", "text": json.dumps(result)}]}

        return {"error": f"Unknown method: {method}"}

    def domain_operation(self, input_data):
        # Your business logic here
        return {"processed": input_data, "status": "success"}

async def main():
    server = CustomMCPServer()
    for line in sys.stdin:
        request = json.loads(line)
        response = await server.handle(request)
        print(json.dumps(response), flush=True)

if __name__ == "__main__":
    asyncio.run(main())
```

### Node.js Custom Server Pattern

**Configuration:**
```json
{
  "mcpServers": {
    "custom-tools": {
      "command": "node",
      "args": ["./mcp-servers/custom-tools.js"]
    }
  }
}
```

---

## Pattern 5: Skill/Agent Integration

### Using MCP Tools in Skills

```markdown
---
name: analytics-skill
description: Generates analytics reports from project data
allowed-tools:
  - Read
  - Write
mcp_tools:
  - mcp__project-db
---

# Analytics Skill

## Data Sources

This skill uses MCP to access the project database:

### Query Examples

**Get user statistics:**
```sql
SELECT COUNT(*) as total_users,
       COUNT(CASE WHEN active THEN 1 END) as active_users
FROM users
```

**Get recent activity:**
```sql
SELECT date, COUNT(*) as events
FROM activity_log
WHERE date > NOW() - INTERVAL '7 days'
GROUP BY date
ORDER BY date
```

## Workflow

1. Query database using `mcp__project-db.query()`
2. Process results
3. Generate report using Write tool
```

### Using MCP Tools in Agents

```markdown
---
name: github-pr-agent
description: Reviews and manages GitHub pull requests
allowed-tools:
  - Read
  - Grep
mcp_tools:
  - mcp__github
color: red
execution_pattern: sequential
---

# GitHub PR Review Agent

## Capabilities

Using the `mcp__github` MCP server, this agent can:
- Fetch PR details and diffs
- Review code changes
- Post review comments
- Check CI status

## Workflow

1. Fetch PR using `mcp__github.get_pull_request()`
2. Analyze changes
3. Post review using `mcp__github.create_review()`
```

---

## Security Best Practices

### 1. Use Environment Variables

**Never hardcode secrets:**
```json
{
  "mcpServers": {
    "secure": {
      "command": "node",
      "args": ["./server.js"],
      "env": {
        "API_KEY": "${MY_SECRET_KEY}",
        "DB_PASSWORD": "${DB_PASS}"
      }
    }
  }
}
```

### 2. Least Privilege Access

**Restrict capabilities:**
```json
{
  "mcpServers": {
    "limited-db": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "--read-only"
      ],
      "env": {
        "POSTGRES_CONNECTION_STRING": "${READONLY_DB_URL}"
      }
    }
  }
}
```

### 3. Scope File Access

**Limit filesystem access:**
```json
{
  "mcpServers": {
    "safe-fs": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "--root", "./safe-directory",
        "--no-follow-symlinks"
      ]
    }
  }
}
```

### 4. Input Validation

**In custom servers, always validate:**
```python
def handle_query(self, args):
    query = args.get("query", "")

    # Prevent SQL injection
    if any(keyword in query.upper() for keyword in ["DROP", "DELETE", "TRUNCATE"]):
        return {"error": "Destructive operations not allowed"}

    # Validate query format
    if not query.strip().upper().startswith("SELECT"):
        return {"error": "Only SELECT queries allowed"}

    return self.execute_query(query)
```

---

## Environment Variable Setup

### Local Development (.env)

```bash
# Database
DATABASE_URL=postgresql://user:pass@localhost:5432/mydb
REDIS_URL=redis://localhost:6379

# APIs
GITHUB_TOKEN=ghp_xxxxxxxxxxxx
SLACK_BOT_TOKEN=xoxb-xxxxxxxxxxxx
SLACK_TEAM_ID=T12345678

# Cloud
GOOGLE_APPLICATION_CREDENTIALS=/path/to/credentials.json
```

### Production (settings.json)

```json
{
  "mcpServers": {
    "production-db": {
      "env": {
        "DATABASE_URL": "${PRODUCTION_DATABASE_URL}"
      }
    }
  }
}
```

---

## Troubleshooting

### Server Won't Start

1. Check command is correct: `npx -y @modelcontextprotocol/server-postgres`
2. Verify environment variables are set
3. Test manually: `echo '{"method":"tools/list"}' | npx -y @modelcontextprotocol/server-postgres`

### Tools Not Discovered

1. Verify `.mcp.json` location (project root or `.claude/`)
2. Check JSON syntax
3. Restart Claude Code after changes

### Authentication Errors

1. Verify API keys/tokens are correct
2. Check token permissions/scopes
3. Ensure environment variables are loaded

### Slow Performance

1. Add connection pooling for databases
2. Use caching for frequently accessed data
3. Consider local MCP servers for high-frequency operations

---

## Related References

- **MCP Generator**: `generators/mcp-generator.md` for creating MCP configurations
- **Tool Restrictions**: `references/tool-restrictions.md` for tool access patterns
- **Web Research**: `references/web-research.md` for external data access
