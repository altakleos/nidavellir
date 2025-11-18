# Security Policy

## Supported Versions

We actively support the following versions with security updates:

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability in this marketplace or any plugin, please report it responsibly.

### How to Report

**DO NOT** open a public GitHub issue for security vulnerabilities.

Instead:

1. **Email**: Send details to `admin@altakleos.com` with subject line "SECURITY: [Brief Description]"
2. **Include**:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if known)
   - Your contact information

### What to Expect

- **Acknowledgment**: Within 48 hours
- **Initial Assessment**: Within 1 week
- **Status Updates**: Every 7 days until resolved
- **Resolution**: Timeline depends on severity

### Severity Levels

We classify vulnerabilities as:

- **Critical**: Immediate remote code execution, data breach
- **High**: Privilege escalation, significant data exposure
- **Medium**: Limited data exposure, authenticated attacks
- **Low**: Minor information disclosure

## Security Best Practices for Plugin Developers

### Do's

1. **Input Validation**: Always validate and sanitize user inputs
2. **Secrets Management**: Never hardcode API keys, tokens, or credentials
3. **Minimal Permissions**: Request only necessary permissions
4. **Dependencies**: Keep dependencies updated and minimal
5. **Code Review**: Have code reviewed before submission
6. **Documentation**: Document security considerations

### Don'ts

1. **No Secrets**: Never commit sensitive information
2. **No Eval**: Avoid using `eval()` or similar dynamic code execution
3. **No System Access**: Don't access system files outside workspace
4. **No Network Calls**: Minimize external API calls; document all that exist
5. **No Obfuscation**: Code should be readable and reviewable

## Plugin Security Review

All submitted plugins undergo security review:

### Automated Checks

- JSON schema validation
- Dependency vulnerability scanning
- Static code analysis
- Secret detection (regex patterns)

### Manual Review

- Code quality and structure
- Permission scope
- External dependencies
- Potential attack vectors

### Red Flags

Plugins will be **rejected** if they:

- Access sensitive system files (`.ssh/`, `.aws/`, etc.)
- Make undocumented network requests
- Contain obfuscated code
- Execute arbitrary system commands without clear justification
- Collect user data without disclosure

## Marketplace Security Features

### Plugin Isolation

- Plugins run in sandboxed environments when possible
- Limited access to file system
- Network requests are monitored

### Version Control

- All plugins are version-controlled
- Changes are tracked via git
- Rollback capability for security issues

### Access Control

- Only authorized AltaKleos team members can publish
- All changes require pull request review
- Two-factor authentication required for maintainers

## Incident Response

If a security issue is discovered in a published plugin:

1. **Immediate Actions**:
   - Plugin is temporarily disabled
   - Users are notified via email
   - Investigation begins

2. **Assessment** (24 hours):
   - Determine scope and impact
   - Identify affected users
   - Develop remediation plan

3. **Remediation** (varies):
   - Fix vulnerability
   - Test thoroughly
   - Publish patched version

4. **Communication**:
   - Update users on status
   - Publish security advisory
   - Document lessons learned

## Security Resources

### For Users

- Review plugin source code before installation
- Keep plugins updated
- Report suspicious behavior
- Follow principle of least privilege

### For Developers

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Claude Code Security Guidelines](https://docs.anthropic.com/en/docs/claude-code/security)
- [GitHub Security Best Practices](https://docs.github.com/en/code-security)

## Vulnerability Disclosure Timeline

After a vulnerability is fixed:

1. **Day 0**: Vulnerability reported privately
2. **Day 1-7**: Assessment and initial fix
3. **Day 8-30**: Testing and validation
4. **Day 30+**: Public disclosure (coordinated)

We aim to fix critical vulnerabilities within 7 days and high-severity issues within 30 days.

## Contact

Security Team: admin@altakleos.com

For general questions (non-security), please use GitHub Issues.

---

Last updated: 2025-01-18
