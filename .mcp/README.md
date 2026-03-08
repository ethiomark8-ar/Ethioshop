# MCP (Model Context Protocol) Configuration

## Overview

This directory contains MCP server configuration files for integrating EthioShop with AI assistants and development tools that support the Model Context Protocol.

## MCP Servers Configured

### 1. Filesystem Server
Provides access to the project file system for AI tools to read, write, and analyze code.

**Configuration**: `.mcp/servers/filesystem.json`

**Capabilities**:
- Read project files
- Write and modify files
- List directory contents
- Search files by content
- Monitor file changes

**Usage**: AI assistants can access the entire EthioShop codebase for code analysis, generation, and refactoring.

---

### 2. Git Server
Provides Git operations and version control context.

**Configuration**: `.mcp/servers/git.json`

**Capabilities**:
- Get commit history
- List branches
- Show diffs
- Get file blame information
- Analyze code changes over time

**Usage**: AI can understand the evolution of the codebase and provide context-aware suggestions.

---

### 3. Search Server
Provides fast code search and indexing capabilities.

**Configuration**: `.mcp/servers/search.json`

**Capabilities**:
- Full-text code search
- Symbol-based search (classes, functions, variables)
- Regex pattern matching
- File path filtering
- Content highlighting

**Usage**: AI can quickly locate specific code patterns, implementations, or references across the entire codebase.

---

### 4. Dart/Flutter Server
Provides Flutter-specific language services and code understanding.

**Configuration**: `.mcp/servers/dart.json`

**Capabilities**:
- Dart language analysis
- Flutter widget tree analysis
- State management pattern detection
- Dependency graph analysis
- Code structure visualization

**Usage**: AI can understand Flutter-specific patterns, widget relationships, and provide Flutter-optimized suggestions.

---

### 5. Firebase Server
Provides Firebase service integration and configuration access.

**Configuration**: `.mcp/servers/firebase.json`

**Capabilities**:
- Firebase project configuration
- Security rules analysis
- Firestore schema understanding
- Authentication flow analysis
- Cloud Functions code analysis

**Usage**: AI can understand Firebase integration patterns and suggest improvements for security, performance, and scalability.

---

### 6. Testing Server
Provides test coverage analysis and test result insights.

**Configuration**: `.mcp/servers/testing.json`

**Capabilities**:
- Test coverage analysis
- Test result parsing
- Test suite organization
- Test failure analysis
- Coverage gap detection

**Usage**: AI can identify untested code, suggest test scenarios, and help improve overall test coverage.

---

### 7. Documentation Server
Provides access to project documentation and code comments.

**Configuration**: `.mcp/servers/documentation.json`

**Capabilities**:
- README parsing
- Documentation comment extraction
- API documentation generation
- Code documentation analysis
- Markdown rendering

**Usage**: AI can understand project documentation and provide context-aware assistance based on documented patterns and guidelines.

---

## Server Configuration Files

Each server has its own configuration file in `.mcp/servers/`:

```json
{
  "name": "server-name",
  "description": "Server description",
  "enabled": true,
  "capabilities": [...],
  "settings": {...}
}
```

## Using MCP Servers

### Claude Desktop Integration

1. Open Claude Desktop settings
2. Navigate to "MCP Servers"
3. Add the EthioShop MCP configuration:
   ```json
   {
     "mcpServers": {
       "ethioshop-filesystem": {
         "command": "npx",
         "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/ethioshop"]
       },
       "ethioshop-git": {
         "command": "npx",
         "args": ["-y", "@modelcontextprotocol/server-git", "/path/to/ethioshop"]
       }
     }
   }
   ```

### Cursor IDE Integration

1. Open Cursor settings
2. Add MCP server configurations
3. Import the EthioShop MCP configuration files

### VS Code with MCP Extension

1. Install the MCP extension for VS Code
2. Add server configurations from `.mcp/servers/`
3. Restart VS Code

## Capabilities Summary

| Server | Read | Write | Search | Analyze | Monitor |
|--------|------|-------|--------|---------|---------|
| Filesystem | ✅ | ✅ | ✅ | ❌ | ✅ |
| Git | ✅ | ✅ | ✅ | ✅ | ❌ |
| Search | ✅ | ❌ | ✅ | ❌ | ❌ |
| Dart/Flutter | ✅ | ❌ | ✅ | ✅ | ❌ |
| Firebase | ✅ | ❌ | ✅ | ✅ | ❌ |
| Testing | ✅ | ❌ | ✅ | ✅ | ❌ |
| Documentation | ✅ | ❌ | ✅ | ✅ | ❌ |

## Security Considerations

- MCP servers run with the same permissions as the user
- Sensitive files (`.env`, `firebase_options.dart`) should be excluded
- Git server can access commit history and author information
- Firebase server should not access production credentials

## Troubleshooting

### Server Not Starting
- Check if Node.js is installed (`node --version`)
- Verify server configuration syntax
- Check MCP client logs for error messages

### File Access Issues
- Ensure correct file paths in configuration
- Check file permissions
- Verify `.mcp/gitignore` exclusions

### Performance Issues
- Exclude large directories from indexing
- Limit search scope in configuration
- Use specific server capabilities when needed

## Customization

You can customize MCP servers by editing their configuration files:

1. **Add new capabilities**: Add to the `capabilities` array
2. **Exclude paths**: Add to `excludes` array
3. **Adjust settings**: Modify `settings` object
4. **Enable/disable**: Set `enabled` to `true`/`false`

## Documentation

- [MCP Protocol Specification](https://spec.modelcontextprotocol.io/)
- [Claude MCP Integration](https://docs.anthropic.com/claude/docs/mcp)
- [Cursor MCP Support](https://cursor.sh/docs/mcp)

## Support

For issues with MCP integration:
1. Check server configuration files
2. Review MCP client logs
3. Verify server dependencies are installed
4. Consult [EthioShop README](../README.md) for project-specific information

---

**Last Updated**: January 2025  
**MCP Version**: Latest  
**EthioShop Version**: 1.0.0