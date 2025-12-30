---
name: postgres-integration-template
type: template
category: mcp
description: Template for PostgreSQL MCP server integration
---

# PostgreSQL MCP Integration Template

## Template Metadata

```yaml
name: postgres-integration
type: mcp
category: database
complexity: simple
package: "@modelcontextprotocol/server-postgres"
```

## Generated .mcp.json

```json
{
  "mcpServers": {
    "{{name | default: 'postgres'}}": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "${{{env_var | default: 'DATABASE_URL'}}}"
      }
    }
  }
}
```

## Generated .env.example

```bash
# PostgreSQL connection string
# Format: postgresql://user:password@host:port/database
{{env_var | default: 'DATABASE_URL'}}=postgresql://user:password@localhost:5432/mydb

# For read-only access (recommended for safety):
# {{env_var | default: 'DATABASE_URL'}}=postgresql://readonly_user:password@localhost:5432/mydb
```

## Generated README

```markdown
# {{name | titlecase}} MCP Integration

PostgreSQL database access for Claude Code.

## Setup

1. **Set environment variable:**
   ```bash
   export {{env_var | default: 'DATABASE_URL'}}="postgresql://user:password@localhost:5432/mydb"
   ```

2. **Install MCP server (automatic on first use):**
   ```bash
   npx -y @modelcontextprotocol/server-postgres
   ```

3. **Restart Claude Code** to pick up the new MCP server.

## Available Tools

Once configured, Claude can use:

- `mcp__{{name | default: 'postgres'}}.query(sql)` - Execute SQL queries
- `mcp__{{name | default: 'postgres'}}.list_tables()` - List database tables
- `mcp__{{name | default: 'postgres'}}.describe_table(name)` - Get table schema

## Example Usage

```
"Query the users table for active users"
→ Uses mcp__{{name | default: 'postgres'}}.query("SELECT * FROM users WHERE active = true")

"Show me the database schema"
→ Uses mcp__{{name | default: 'postgres'}}.list_tables()
→ Uses mcp__{{name | default: 'postgres'}}.describe_table() for each table
```

## Security Best Practices

{{#if readonly}}
### Read-Only Mode (Recommended)
This integration is configured for read-only access. The database user should only have SELECT permissions.
{{else}}
### Full Access Mode
This integration has full database access. Consider using a limited user for production.
{{/if}}

1. **Use environment variables** - Never hardcode connection strings
2. **Limit permissions** - Use a database user with minimal required access
3. **Use read-only when possible** - Prevents accidental data modification
4. **Audit queries** - Enable query logging in production

## Troubleshooting

### Connection Failed
- Verify `{{env_var | default: 'DATABASE_URL'}}` is set correctly
- Check database is accessible from your machine
- Verify user credentials

### Permission Denied
- Check database user has required permissions
- For read-only: Grant SELECT on required tables
- For full access: Grant SELECT, INSERT, UPDATE, DELETE

### MCP Server Not Found
- Run: `npx -y @modelcontextprotocol/server-postgres`
- Restart Claude Code after configuration changes
```

## Customization Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `name` | MCP server name | `postgres` |
| `env_var` | Environment variable name | `DATABASE_URL` |
| `readonly` | Generate read-only config | false |

## Usage

```
/forge:template postgres-integration
/forge:template postgres-integration --name analytics-db --env-var ANALYTICS_DB_URL
/forge:template postgres-integration --readonly --name reporting
```

## Multiple Databases

For multiple databases, run the template multiple times:

```
/forge:template postgres-integration --name main-db --env-var MAIN_DB_URL
/forge:template postgres-integration --name analytics --env-var ANALYTICS_URL
```

This creates:
```json
{
  "mcpServers": {
    "main-db": { ... },
    "analytics": { ... }
  }
}
```
