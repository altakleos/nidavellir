---
name: debugging-guide
type: reference
description: Debugging strategies for skills, agents, and suites
---

# Debugging Guide - Troubleshooting Extensions

Comprehensive guide to debugging different types of Claude Code extensions.

## Debugging Skills

### Common Issues

**Issue: Skill doesn't load**
- Check YAML frontmatter syntax
- Verify all required fields present
- Look for malformed markdown

**Issue: Skill behavior unexpected**
- Review skill instructions
- Check for context misunderstandings
- Verify examples match intent

**Issue: Python scripts failing**
- Check Python syntax
- Verify dependencies installed
- Review error messages

**Issue: Slow performance**
- Check for unnecessary operations
- Review algorithm complexity
- Consider caching strategies

### Debugging Strategies

1. **Read the Error Message:** Often points directly to problem
2. **Check Frontmatter:** Validate YAML syntax
3. **Test Examples:** Run sample prompts
4. **Isolate Components:** Test parts independently
5. **Add Logging:** Track execution flow

## Debugging Agents

### Common Issues

**Issue: Agent doesn't auto-invoke**
- Check description clarity
- Verify trigger conditions
- Look for description conflicts
- Test with explicit invocation

**Issue: Tool access denied**
- Check tools declared in frontmatter
- Verify tool access permissions
- Review safety restrictions

**Issue: Parallel execution problems**
- Check if quality agent (must be sequential)
- Verify parallel-safe tool combinations
- Review process load

**Issue: Agent conflicts with others**
- Check for description overlap
- Verify no resource conflicts
- Review execution patterns

### Debugging Strategies

1. **Test Description:** Does it clearly describe when to invoke?
2. **Check Tools:** Are all needed tools declared?
3. **Verify Execution Pattern:** Matches function type?
4. **Test Independently:** Works alone before coordination?
5. **Review Logs:** Check invocation attempts

### Debug Checklist for Agents

```markdown
□ Description is action-oriented
□ Description specifies trigger
□ Description is 10+ words
□ Tools match what's used in content
□ Execution pattern is safe
□ Quality agents marked sequential
□ No Bash in parallel (unless strategic)
□ Process load estimated
□ Integration points documented
```

## Debugging Suites

### Common Issues

**Issue: Suite coordination failures**
- Check dependency chain
- Verify data flow configuration
- Look for circular dependencies
- Review synchronization points

**Issue: Parallel execution crashes**
- Check for parallel quality agents (important)
- Verify concurrency limits respected
- Review total process load

**Issue: Data not flowing between agents**
- Check data_flow configuration
- Verify output/input formats match
- Review shared storage access

**Issue: Performance bottlenecks**
- Identify slowest agent
- Check for unnecessary sequential execution
- Review process load distribution

### Debugging Strategies

1. **Visualize Execution:** Draw the coordination flow
2. **Test Phases:** Run each phase independently
3. **Verify Data Flow:** Check data passes correctly
4. **Monitor Process Load:** Track resource usage
5. **Check Logs:** Review execution sequence

### Debug Checklist for Suites

```markdown
□ No circular dependencies
□ Quality agents run sequentially
□ Concurrency limits respected
□ Total process load < 60
□ Data flow defined clearly
□ Failure strategy specified
□ Integration tested
□ Each agent works independently
```

## Debugging Hybrid Solutions

### Common Issues

**Issue: Skill-agent coordination problems**
- Check invocation logic in skill
- Verify agent availability
- Review data passing

**Issue: Context confusion**
- Clarify what skill manages vs agents
- Review boundary definitions
- Check state management

**Issue: Performance issues**
- Review when agents are invoked
- Check for unnecessary agent calls
- Consider caching agent results

### Debugging Strategies

1. **Test Components:** Skill and agents separately
2. **Check Integration:** Verify communication works
3. **Review Boundaries:** Clear separation of concerns?
4. **Monitor Coordination:** Track invocation patterns
5. **Verify Data Flow:** Check data passing

## Common Error Patterns

### Error: "Quality agents in parallel"
**Cause:** Quality agents marked as parallel
**Fix:** Change to sequential execution
**Prevention:** Always mark quality agents sequential

### Error: "Process load exceeded"
**Cause:** Too many concurrent agents
**Fix:** Reduce concurrency or split phases
**Prevention:** Estimate process loads during design

### Error: "Circular dependency detected"
**Cause:** Agent A depends on B depends on A
**Fix:** Restructure dependencies
**Prevention:** Validate dependency graph

### Error: "Description overlap"
**Cause:** Two agents have similar descriptions
**Fix:** Make descriptions more specific
**Prevention:** Check uniqueness during generation

### Error: "Tool access denied"
**Cause:** Using tool not declared in frontmatter
**Fix:** Add tool to frontmatter
**Prevention:** Declare all needed tools upfront

## Performance Debugging

### Slow Extension Performance

**Diagnose:**
1. Time each operation
2. Identify bottleneck
3. Profile resource usage
4. Check for unnecessary operations

**Optimize:**
- Cache repeated operations
- Parallelize independent operations
- Reduce tool usage
- Optimize algorithms

### High Process Load

**Diagnose:**
1. Check concurrent agents count
2. Review individual agent loads
3. Verify execution patterns

**Fix:**
- Reduce concurrency
- Split into phases
- Use lighter agents
- Optimize agent complexity

## Testing Strategies

### Unit Testing Extensions

**For Skills:**
```bash
# Test with sample prompts
claude test skill ./my-skill/ --prompt "Test scenario"
```

**For Agents:**
```bash
# Test auto-invocation
python scripts/validate_agent.py ./my-agent/

# Test explicit invocation
claude test agent ./my-agent/ --scenario "trigger condition"
```

**For Suites:**
```bash
# Test suite coordination
python scripts/test_suite.py ./my-suite/

# Test individual agents
for agent in suite/agents/*; do
    claude test agent $agent
done
```

### Integration Testing

**Test Extension Loading:**
- Does it load without errors?
- Are all dependencies available?
- Does frontmatter parse correctly?

**Test Functionality:**
- Do examples work as expected?
- Does auto-invocation trigger correctly?
- Do outputs match expectations?

**Test Integration:**
- Does it work with other extensions?
- Are there any conflicts?
- Does coordination work?

## Debugging Tools

### Validation Scripts

**validate_agent.py:**
```bash
python scripts/validate_agent.py ./my-agent/
# Checks syntax, safety, description clarity
```

**analyze_extension.py:**
```bash
python scripts/analyze_extension.py ./my-skill/
# Analyzes characteristics, suggests improvements
```

### Monitoring

**Process Load Monitoring:**
```bash
# Check current process count
ps aux | wc -l

# Monitor during execution
watch "ps aux | wc -l"
```

**Execution Tracing:**
- Add logging to track execution
- Monitor agent invocations
- Track data flow

## Getting Help

When stuck:
1. Review this debugging guide
2. Check extension examples
3. Verify against patterns
4. Test with simpler version
5. Ask for help with specific error

Include in help request:
- Extension type
- Error message
- What you tried
- Minimal reproduction
- Configuration/frontmatter

This guide helps quickly identify and resolve issues across all extension types.
