# Quality Criteria - Context-Aware Excellence

Quality isn't absolute - it's contextual. What makes a skill excellent depends entirely on who will use it and how. This reference helps me calibrate quality to each unique situation.

## Universal Quality Principles

### Clarity of Purpose
Every skill should know exactly what it does and communicate it clearly.

**Excellent:**
"I analyze sales data to identify your top-performing products and suggest inventory optimizations."

**Poor:**
"I help with data analysis and reporting tasks."

### Appropriate Complexity
Match complexity to need - don't over-engineer simple tasks or under-engineer complex ones.

**Context Calibration:**
- **Startup**: Lean toward simple, even if it means limitations
- **Enterprise**: Lean toward robust, even if it means complexity
- **Regulated**: Complexity justified by compliance needs

### User-Centric Design
Think about how the user will actually use this, not how it could theoretically be used.

**Key Questions:**
- What's the user's typical workflow?
- What friction points exist currently?
- What's the minimum viable improvement?
- What would delight them?

## Documentation Quality

### For Non-Technical Users

**Excellent Documentation:**
```markdown
## How to Use This Skill

1. **Prepare Your Data**
   Open Excel and save your sales data as "sales.csv"
   (Don't worry about formatting - I'll handle that)

2. **Start the Analysis**
   Upload the file when I ask for it
   (I'll guide you through each step)

3. **Get Your Results**
   You'll receive a simple PDF report
   (Everything important is on page 1)

## Common Questions

**What if my data looks different?**
That's fine! I'll adapt to your format and let you know if I need anything.

**What if something goes wrong?**
I'll explain exactly what happened and how to fix it. No technical jargon.
```

### For Technical Teams

**Excellent Documentation:**
```markdown
## API Reference

### Core Interface

```python
async def process_pipeline(
    data: DataStream,
    config: PipelineConfig = None
) -> ProcessedResult:
    """
    Execute processing pipeline with optional configuration.

    Args:
        data: AsyncIterator[Dict] following schema v2.1
        config: Optional PipelineConfig (defaults to env)

    Returns:
        ProcessedResult with metrics and transformed data

    Raises:
        ValidationError: Schema validation failure
        ProcessingError: Pipeline execution failure

    Performance:
        - Throughput: 10K records/sec (p99)
        - Latency: 50ms (p99)
        - Memory: O(batch_size), not O(n)
    """
```

### Configuration

See `config.yaml` for full options. Key parameters:
- `batch_size`: Default 1000, max 10000
- `parallelism`: Default CPU count, max 32
- `retry_policy`: Exponential backoff with jitter
```

## Code Quality Criteria

### Clean Code Principles

**Readability Over Cleverness**

Good:
```python
def calculate_discount(price, customer_type):
    if customer_type == "premium":
        return price * 0.8  # 20% discount
    elif customer_type == "regular":
        return price * 0.9  # 10% discount
    else:
        return price
```

Avoid:
```python
def calc_disc(p, t):
    return p * {"premium": 0.8, "regular": 0.9}.get(t, 1)
```

### Error Handling Philosophy

**Context-Appropriate Strategies:**

**For Startups (Fail Fast):**
```python
def process_data(data):
    # Quick failure for quick debugging
    assert data is not None, "Data cannot be None"
    result = transform(data)  # Let exceptions bubble up
    return result
```

**For Enterprise (Fail Gracefully):**
```python
def process_data(data):
    try:
        if not validate_data(data):
            logger.warning(f"Invalid data: {data}")
            return ProcessResult(success=False, error="INVALID_DATA")

        result = transform(data)
        audit_log.record(f"Processed {len(data)} records")
        return ProcessResult(success=True, data=result)

    except TransformError as e:
        logger.error(f"Transform failed: {e}")
        alert_ops_team(e)
        return ProcessResult(success=False, error=str(e))
```

### Performance Criteria

**Calibrated to Scale:**

**Small Scale (Optimize for Simplicity):**
```python
# Clear, simple, maintainable
results = []
for item in items:
    processed = process_item(item)
    results.append(processed)
return results
```

**Large Scale (Optimize for Performance):**
```python
# Performance-optimized with batching and parallelism
from concurrent.futures import ThreadPoolExecutor
from itertools import batched

def process_batch(batch):
    return [process_item(item) for item in batch]

with ThreadPoolExecutor(max_workers=8) as executor:
    batches = batched(items, n=1000)
    futures = [executor.submit(process_batch, batch) for batch in batches]
    results = [item for future in futures for item in future.result()]
```

## Validation Appropriateness

### Input Validation Spectrum

**Permissive (Analytics/Exploration):**
```python
def analyze_data(data):
    # Work with what we have
    if not data:
        return {"status": "No data to analyze"}

    # Handle missing fields gracefully
    clean_data = []
    for record in data:
        if 'value' in record:
            clean_data.append(record)

    # Continue with available data
    return perform_analysis(clean_data)
```

**Strict (Financial/Regulatory):**
```python
def process_transaction(transaction):
    # Validate everything
    required_fields = ['amount', 'account', 'date', 'authorization']

    for field in required_fields:
        if field not in transaction:
            raise ValidationError(f"Missing required field: {field}")

    if not validate_amount(transaction['amount']):
        raise ValidationError(f"Invalid amount: {transaction['amount']}")

    if not validate_account(transaction['account']):
        raise ValidationError(f"Invalid account: {transaction['account']}")

    # Only process if perfect
    return execute_transaction(transaction)
```

## Feature Completeness

### MVP vs Enterprise Features

**MVP Feature Set (Startup):**
- Core functionality that delivers value
- Basic error handling
- Simple configuration
- Minimal dependencies
- Quick start guide

**Enterprise Feature Set:**
- Comprehensive functionality
- Advanced error handling with recovery
- Extensive configuration options
- Integration with enterprise systems
- Detailed documentation
- Monitoring and metrics
- Audit trails
- Role-based access

### Feature Priority Matrix

```
Feature Priority by Context:

                    Startup  Growth  Enterprise
Core Function         ████    ████     ████
Error Recovery        ██      ███      ████
Configuration         ██      ███      ████
Integration           █       ███      ████
Documentation         ██      ███      ████
Security              ██      ███      ████
Audit/Compliance      █       ██       ████
Performance           ██      ███      ████
Scalability           █       ███      ████
```

## Testing Standards

### Test Coverage by Context

**Minimal Testing (Prototype):**
- Smoke test for happy path
- Manual testing acceptable
- Focus on "does it work?"

**Standard Testing (Production):**
- Unit tests for core functions
- Integration tests for workflows
- Error case coverage
- 70%+ code coverage

**Comprehensive Testing (Mission-Critical):**
- Unit tests with edge cases
- Integration tests with failure scenarios
- Performance testing under load
- Security testing
- Chaos engineering tests
- 90%+ code coverage

## Security Criteria

### Security by Sensitivity

**Low Sensitivity (Public Data):**
- Basic input sanitization
- Standard error messages
- HTTP/HTTPS acceptable

**Medium Sensitivity (Business Data):**
- Input validation and sanitization
- Secure error handling (no data leakage)
- HTTPS required
- Authentication required
- Basic audit logging

**High Sensitivity (PII/Financial/Health):**
- Comprehensive input validation
- Secure coding practices
- Encrypted transmission and storage
- Strong authentication + authorization
- Detailed audit trails
- Compliance with regulations
- Security review required

## Maintenance Considerations

### Documentation Maintenance Burden

**Low Maintenance Needs:**
- Self-explanatory code
- Minimal configuration
- Standard patterns
- Few dependencies

**High Maintenance Needs:**
- Complex business logic
- Multiple integrations
- Custom configurations
- Many dependencies
- Compliance requirements

**Balance Point:**
Document what's surprising, not what's obvious.

## Quality Trade-offs

### When to Prioritize Speed Over Quality

**Appropriate for Speed:**
- Proof of concepts
- Internal tools
- Short-lived utilities
- Rapid prototyping
- Innovation experiments

**Speed Indicators:**
- "Just need something working"
- "Temporary solution"
- "Let's test the idea"

### When to Prioritize Quality Over Speed

**Appropriate for Quality:**
- Production systems
- Customer-facing tools
- Regulatory compliance
- Financial calculations
- Long-term solutions

**Quality Indicators:**
- "This will be used daily"
- "Multiple teams depend on this"
- "Audit requirement"

## Excellence Indicators

### Signs of an Excellent Skill

1. **It feels tailored**: Users feel it was built just for them
2. **It reduces friction**: Makes the hard easy
3. **It's predictable**: Behaves as expected
4. **It's forgiving**: Handles mistakes gracefully
5. **It's informative**: Provides useful feedback
6. **It evolves well**: Easy to enhance
7. **It's trustworthy**: Reliable and consistent

### Anti-Excellence Patterns

1. **Over-generic**: Tries to solve every problem, solves none well
2. **Over-specific**: So narrow it's inflexible
3. **Over-engineered**: Complex beyond its needs
4. **Under-documented**: Assumes too much knowledge
5. **Fragile**: Breaks with small changes
6. **Opaque**: Doesn't explain what it's doing
7. **Rigid**: Can't adapt to variations

## Context-Specific Excellence

### Startup Excellence
- Ships quickly
- Solves real problem
- Easy to iterate
- Clear value proposition
- Minimal barriers to use

### Enterprise Excellence
- Integrates seamlessly
- Scales reliably
- Governs properly
- Documents thoroughly
- Maintains easily

### Regulatory Excellence
- Complies completely
- Audits transparently
- Fails safely
- Documents rigorously
- Controls precisely

## The Meta-Quality: Appropriateness

The highest quality is **appropriateness** - the skill fits its context perfectly. This means:

- Right complexity for the team
- Right robustness for the use case
- Right documentation for the audience
- Right features for the need
- Right architecture for the scale
- Right security for the sensitivity

A "lower quality" skill that fits perfectly is better than a "higher quality" skill that doesn't fit at all.

## Quality Evolution Path

Skills should be designed to evolve:

**Version 1.0**: Core value, basic quality
**Version 1.1**: Bug fixes, edge cases
**Version 2.0**: Enhanced features, better quality
**Version 3.0**: Platform capabilities, enterprise quality

Each version's quality should match its maturity stage. Don't build v3.0 quality for v1.0 needs.