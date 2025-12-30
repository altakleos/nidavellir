---
name: mcp-generator
type: module
description: Creates MCP (Model Context Protocol) server configurations for Claude Code integrations
---

# MCP Generator - Model Context Protocol Server Creation

This module creates MCP server configurations - standardized integrations that extend Claude Code with external tool capabilities. MCP is becoming the universal standard for connecting AI agents to tools and data sources.

## When This Generator is Used

The MCP generator is invoked when the decision framework detects:
- External service integration requirements
- Database or API connectivity needs
- Tool augmentation beyond built-in capabilities
- Cross-platform interoperability requirements
- Standardized protocol needs

## Understanding MCP (Model Context Protocol)

### What is MCP?

MCP is an open standard for connecting AI assistants to external tools and data sources. It provides:
- **Standardized communication** between AI and tools
- **Tool discovery** - Claude can discover available capabilities
- **Cross-platform compatibility** - Works with multiple AI systems
- **Security boundaries** - Clear separation of concerns

### MCP Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Claude Code                           │
├─────────────────────────────────────────────────────────┤
│  Built-in Tools    │    MCP Client                      │
│  - Read            │    - Discovers servers             │
│  - Write           │    - Routes tool calls             │
│  - Bash            │    - Manages connections           │
│  - etc.            │                                    │
└────────────────────┴────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│                    MCP Servers                           │
├─────────────┬───────────────┬───────────────────────────┤
│  Database   │    API        │     Custom                │
│  - postgres │    - github   │     - your-tools          │
│  - sqlite   │    - slack    │     - domain-specific     │
│  - redis    │    - jira     │                           │
└─────────────┴───────────────┴───────────────────────────┘
```

### MCP Server Types

| Type | Description | Examples |
|------|-------------|----------|
| **Database** | Connect to databases | PostgreSQL, SQLite, MongoDB, Redis |
| **API** | Integrate with services | GitHub, Slack, Jira, Linear |
| **File System** | Extended file operations | Cloud storage, network drives |
| **Custom** | Domain-specific tools | Business logic, proprietary systems |

## MCP Generation Framework

### Phase 1: Integration Analysis

Determine the MCP server type and capabilities needed:

```python
def analyze_mcp_needs(requirements):
    mcp_config = {
        "type": None,
        "transport": "stdio",  # or "http", "sse"
        "capabilities": [],
        "authentication": None
    }

    if requirements.needs_database:
        mcp_config["type"] = "database"
        mcp_config["capabilities"] = ["query", "list_tables", "describe_schema"]

    elif requirements.needs_api:
        mcp_config["type"] = "api"
        mcp_config["capabilities"] = detect_api_capabilities(requirements.api_type)

    elif requirements.needs_custom_tools:
        mcp_config["type"] = "custom"
        mcp_config["capabilities"] = requirements.tool_list

    if requirements.needs_auth:
        mcp_config["authentication"] = detect_auth_type(requirements)

    return mcp_config
```

### Phase 2: Server Configuration

Generate the `.mcp.json` configuration file:

**Standard MCP Configuration:**

```json
{
  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-package"],
      "env": {
        "API_KEY": "${API_KEY}"
      }
    }
  }
}
```

**Configuration Options:**

| Field | Description | Required |
|-------|-------------|----------|
| `command` | Executable to run | Yes |
| `args` | Command arguments | No |
| `env` | Environment variables | No |
| `cwd` | Working directory | No |
| `transport` | Communication method | No (default: stdio) |

### Phase 3: Popular MCP Server Configurations

#### Database Servers

**PostgreSQL:**
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "${POSTGRES_URL}"
      }
    }
  }
}
```

**SQLite:**
```json
{
  "mcpServers": {
    "sqlite": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sqlite", "--db-path", "./data.db"]
    }
  }
}
```

**Redis:**
```json
{
  "mcpServers": {
    "redis": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-redis"],
      "env": {
        "REDIS_URL": "${REDIS_URL}"
      }
    }
  }
}
```

#### API Integration Servers

**GitHub:**
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

**Slack:**
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

**Linear:**
```json
{
  "mcpServers": {
    "linear": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-linear"],
      "env": {
        "LINEAR_API_KEY": "${LINEAR_API_KEY}"
      }
    }
  }
}
```

#### File System Servers

**Google Drive:**
```json
{
  "mcpServers": {
    "gdrive": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-gdrive"],
      "env": {
        "GOOGLE_CREDENTIALS": "${GOOGLE_CREDENTIALS_PATH}"
      }
    }
  }
}
```

**Filesystem (Extended):**
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "--root", "/path/to/root"]
    }
  }
}
```

### Phase 4: Custom MCP Server Generation

For domain-specific needs, generate a custom MCP server:

**Python MCP Server Template:**

```python
#!/usr/bin/env python3
"""
Custom MCP Server: [server-name]
Description: [what this server provides]
"""

import asyncio
import json
import sys
from typing import Any

# MCP protocol implementation
class MCPServer:
    def __init__(self):
        self.tools = {}
        self.register_tools()

    def register_tools(self):
        """Register available tools."""
        self.tools = {
            "tool_name": {
                "description": "What this tool does",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "param1": {"type": "string", "description": "Parameter description"}
                    },
                    "required": ["param1"]
                }
            }
        }

    async def handle_request(self, request: dict) -> dict:
        """Handle incoming MCP requests."""
        method = request.get("method")

        if method == "tools/list":
            return {"tools": list(self.tools.values())}

        elif method == "tools/call":
            tool_name = request["params"]["name"]
            arguments = request["params"].get("arguments", {})
            result = await self.call_tool(tool_name, arguments)
            return {"content": [{"type": "text", "text": json.dumps(result)}]}

        return {"error": f"Unknown method: {method}"}

    async def call_tool(self, name: str, arguments: dict) -> Any:
        """Execute a tool and return results."""
        # Implement your tool logic here
        if name == "tool_name":
            return self.execute_tool_name(arguments)
        raise ValueError(f"Unknown tool: {name}")

    def execute_tool_name(self, args: dict) -> dict:
        """Implementation for tool_name."""
        # Your custom logic here
        return {"result": "success", "data": args}

async def main():
    server = MCPServer()

    # Read from stdin, write to stdout (stdio transport)
    reader = asyncio.StreamReader()
    protocol = asyncio.StreamReaderProtocol(reader)
    await asyncio.get_event_loop().connect_read_pipe(lambda: protocol, sys.stdin)

    while True:
        line = await reader.readline()
        if not line:
            break

        request = json.loads(line.decode())
        response = await server.handle_request(request)
        print(json.dumps(response), flush=True)

if __name__ == "__main__":
    asyncio.run(main())
```

**Node.js MCP Server Template:**

```javascript
#!/usr/bin/env node
/**
 * Custom MCP Server: [server-name]
 * Description: [what this server provides]
 */

const readline = require('readline');

class MCPServer {
  constructor() {
    this.tools = this.registerTools();
  }

  registerTools() {
    return {
      tool_name: {
        description: "What this tool does",
        inputSchema: {
          type: "object",
          properties: {
            param1: { type: "string", description: "Parameter description" }
          },
          required: ["param1"]
        }
      }
    };
  }

  async handleRequest(request) {
    const { method, params } = request;

    switch (method) {
      case "tools/list":
        return { tools: Object.values(this.tools) };

      case "tools/call":
        const result = await this.callTool(params.name, params.arguments || {});
        return { content: [{ type: "text", text: JSON.stringify(result) }] };

      default:
        return { error: `Unknown method: ${method}` };
    }
  }

  async callTool(name, args) {
    switch (name) {
      case "tool_name":
        return this.executeToolName(args);
      default:
        throw new Error(`Unknown tool: ${name}`);
    }
  }

  executeToolName(args) {
    // Your custom logic here
    return { result: "success", data: args };
  }
}

async function main() {
  const server = new MCPServer();

  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false
  });

  rl.on('line', async (line) => {
    const request = JSON.parse(line);
    const response = await server.handleRequest(request);
    console.log(JSON.stringify(response));
  });
}

main();
```

### Phase 5: Security Configuration

Ensure MCP servers are configured securely:

**Environment Variables:**

Never hardcode secrets in configuration:

```json
{
  "mcpServers": {
    "secure-server": {
      "command": "node",
      "args": ["./server.js"],
      "env": {
        "API_KEY": "${MY_API_KEY}",
        "DB_PASSWORD": "${DB_PASSWORD}"
      }
    }
  }
}
```

**Access Scoping:**

Limit what MCP servers can access:

```json
{
  "mcpServers": {
    "limited-filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "--root", "./safe-directory",
        "--read-only"
      ]
    }
  }
}
```

**Security Best Practices:**

1. **Least Privilege**: Only grant necessary permissions
2. **Environment Variables**: Use `${VAR}` syntax for secrets
3. **Sandboxing**: Restrict file system access
4. **Validation**: Validate all inputs in custom servers
5. **Logging**: Log access for audit trails

### Phase 6: Integration with Claude Code

**Plugin Configuration:**

Add MCP servers to plugin.json:

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "skills": ["SKILL.md"],
  "mcpServers": ".mcp.json"
}
```

**Using MCP Tools in Skills/Agents:**

```markdown
---
name: database-skill
description: Queries project database for analytics
allowed-tools:
  - Read
  - Grep
mcp_tools:
  - mcp__postgres
---

# Database Analytics Skill

## Using MCP Tools

This skill uses the `mcp__postgres` tool to query the database:

```
mcp__postgres.query({
  "sql": "SELECT * FROM users WHERE active = true"
})
```
```

### Phase 7: Testing and Validation

**Test MCP Server Locally:**

```bash
# Test stdio transport
echo '{"method":"tools/list"}' | npx -y @modelcontextprotocol/server-postgres

# Test custom server
echo '{"method":"tools/list"}' | python3 ./my-server.py
```

**Validation Checklist:**

- [ ] Server starts without errors
- [ ] `tools/list` returns expected tools
- [ ] `tools/call` executes correctly
- [ ] Environment variables are read properly
- [ ] Error handling works as expected
- [ ] No secrets in configuration files

## Output Structure

Generate complete MCP package:

```
my-mcp-integration/
├── .mcp.json                    # MCP server configuration
├── server/
│   ├── server.py               # Custom server (if needed)
│   ├── server.js               # Or Node.js version
│   └── requirements.txt        # Python dependencies
├── README.md                   # Setup and usage guide
└── .env.example               # Environment variable template
```

## Common Integration Patterns

### Database Query Pattern

```json
{
  "mcpServers": {
    "analytics-db": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "${ANALYTICS_DB_URL}"
      }
    }
  }
}
```

### Multi-Service Pattern

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
      "args": ["-y", "@modelcontextprotocol/server-linear"],
      "env": {"LINEAR_API_KEY": "${LINEAR_API_KEY}"}
    },
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {"SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}"}
    }
  }
}
```

### Custom + Standard Pattern

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {"POSTGRES_CONNECTION_STRING": "${DB_URL}"}
    },
    "custom-tools": {
      "command": "python3",
      "args": ["./server/custom-tools.py"],
      "cwd": "${workspaceFolder}"
    }
  }
}
```

## Related Modules

- **Decision Framework**: See `core/decision-framework.md` for when to use MCP
- **Validation**: See `core/validation-framework.md` for validation rules
- **References**: See `references/mcp-patterns.md` for detailed patterns
- **Other Generators**:
  - Hooks: `generators/hook-generator.md`
  - Skills: `generators/skill-generator.md`
  - Agents: `generators/agent-generator.md`

## Success Criteria

A successful MCP integration:
- Connects reliably to external service
- Exposes tools discoverable by Claude
- Handles authentication securely
- Fails gracefully with clear errors
- Documents setup requirements clearly
- Follows security best practices
