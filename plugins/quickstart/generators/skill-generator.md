---
name: skill-generator
type: module
description: Sophisticated skill creation with context-aware adaptation
---

# Skill Generator - Integrated Extension Creation

This module creates skills - integrated Claude Code extensions that work within the main conversation context with deep contextual understanding and adaptive complexity.

## When This Generator is Used

The skill generator is invoked when the decision framework determines:
- Heavy context dependency
- Custom, one-time solution needed
- Tightly coupled operations
- Requires full conversation integration
- No benefit from auto-invocation or tool restrictions

## Skill Generation Framework

### Phase 1: Architectural Design

Based on discovery context, determine skill architecture:

**Workflow Architecture:**
- Sequential: Step-by-step processing
- Parallel: Concurrent operations where possible
- Conditional: Decision-based branching
- Iterative: Batch processing patterns
- Event-driven: Reactive operations

**Coupling Strategy:**
- Tight coupling → Unified skill
- Medium coupling → Modular sections
- Loose coupling → Consider suggesting agents instead

**Complexity Calibration:**
- User technical level (beginner/intermediate/expert)
- Team capability (solo/small/department/enterprise)
- Business maturity (startup/growth/established/enterprise)

### Phase 2: Contextual Content Generation

Generate SKILL.md content tailored to user context:

**Frontmatter Generation:**
```yaml
---
name: [descriptive-kebab-case-name]
description: [Clear value proposition in user's terminology]
version: 1.0.0
author: [User or team name]
keywords: [Domain-relevant keywords]
complexity: [beginner|intermediate|advanced based on analysis]
domain: [business domain]
---
```

**Main Skill Content Structure:**

1. **Opening Section** (Context-Adapted)
   - Beginner: Simple explanation of what it does
   - Intermediate: Value proposition and use cases
   - Expert: Technical capabilities and integration points

2. **Core Instructions** (Sophistication-Adapted)
   - Beginner: Step-by-step, clear instructions
   - Intermediate: Balanced automation with flexibility
   - Expert: Advanced patterns and optimization

3. **Workflow Sections** (Pattern-Based)
   - Match discovered workflow patterns
   - Include relevant context handling
   - Address integration points

4. **Examples** (Context-Specific)
   - Use user's terminology
   - Address user's actual use cases
   - Show realistic scenarios

5. **Quality Standards** (Context-Appropriate)
   - Startup: Speed and flexibility
   - SMB: Balance of quality and speed
   - Enterprise: Robustness and governance
   - Regulated: Compliance and audit trails

### Phase 3: Python Support (If Needed)

Determine if Python scripts are beneficial:

**When to Include Python:**
- Complex calculations or data processing
- External API integrations
- File format conversions
- Performance-critical operations
- Reusable utility functions

**When to Skip Python:**
- Simple prompt-based logic
- Conversational workflows
- No computational complexity
- User prefers pure Claude interaction

**Python Code Generation Principles:**
- Match user's technical level in code complexity
- Include appropriate error handling for context
- Document according to team capability
- Follow domain-specific best practices

### Phase 4: Supporting Materials

Generate contextually appropriate supporting materials:

**sample_prompt.md:**
- Copy-paste ready examples
- Use user's actual terminology
- Address their specific use cases
- Show various interaction patterns

**HOW_TO_USE.md (if complex):**
- Usage guide matching technical level
- Troubleshooting section
- Integration with existing workflow
- Best practices for their context

**Test Data (if applicable):**
- Sample data matching their domain
- Realistic scenarios
- Edge cases relevant to their use

## Context-Adaptive Code Generation

### Technical Level Adaptation

**Beginner Level:**
```python
def calculate_total(items):
    """
    This function adds up all the item prices.

    Args:
        items: A list of items, each with a 'price' field

    Returns:
        The total price of all items
    """
    total = 0
    for item in items:
        total = total + item['price']
    return total
```

**Intermediate Level:**
```python
def calculate_total(items: List[Dict[str, Any]]) -> Decimal:
    """Calculate total price with proper decimal handling."""
    return sum(Decimal(str(item['price'])) for item in items)
```

**Advanced Level:**
```python
class PriceCalculator(Generic[T]):
    """High-performance price calculation engine with pluggable strategies."""

    def __init__(self, strategy: CalculationStrategy):
        self._strategy = strategy

    async def calculate_total(
        self,
        items: Sequence[T],
        dimensions: Optional[List[Dimension]] = None
    ) -> CalculationResult:
        """Calculate with configurable dimensions and async processing."""
        return await self._strategy.calculate(items, dimensions)
```

### Domain Adaptation

**Healthcare Domain:**
- HIPAA compliance considerations
- Audit trail requirements
- Patient data handling
- Security-first approach

**Financial Domain:**
- Precision in calculations (Decimal, not float)
- Audit trails
- Regulatory compliance
- Transaction integrity

**E-commerce Domain:**
- Inventory management patterns
- Order processing workflows
- Customer data handling
- Integration with payment systems

**SaaS/Startup Domain:**
- Speed over perfection
- Flexibility for rapid changes
- Simple deployment
- Growth accommodation

## Quality Calibration

### Quality Dimensions Matrix

Apply appropriate emphasis based on context:

**Startup Context:**
- Speed: ████ (highest priority)
- Flexibility: ████
- Robustness: ██
- Documentation: ██

**SMB Context:**
- Speed: ███
- Flexibility: ███
- Robustness: ███
- Documentation: ███

**Enterprise Context:**
- Speed: ██
- Flexibility: ██
- Robustness: ████
- Documentation: ████
- Governance: ████

**Regulated Context:**
- Speed: █
- Flexibility: █
- Robustness: ████
- Documentation: ████
- Compliance: ████
- Audit: ████

## Pattern Application

Learn from and apply relevant patterns from the pattern library:

**Data Transformation Pattern:**
- Input validation
- Transformation logic
- Output formatting
- Error handling

**Analysis Pattern:**
- Data gathering
- Computation
- Interpretation
- Presentation

**Generation Pattern:**
- Template selection
- Customization
- Production
- Delivery

**Integration Pattern:**
- Source connection
- Data mapping
- Transformation
- Destination delivery

**Orchestration Pattern:**
- Monitoring
- Decision making
- Action execution
- Verification

## Terminology Alignment

Use the user's vocabulary throughout:

**Vocabulary Extraction:**
- Note terms user uses for key concepts
- Use their terminology consistently
- Don't replace with "standard" terms

**Examples:**
- User says "client" → Use "client" (not "customer")
- User says "MRR" → Use "MRR" (not "monthly recurring revenue")
- User says "cust_id" → Use "cust_id" (not "customer_id")

## Evolution Planning

Design skills to evolve with the user:

**Current Stage Design:**
- Solve immediate need
- Match current capability
- Appropriate complexity

**Growth Accommodation:**
- Clean architecture for extension
- Modular sections for future enhancement
- Comment hooks for future features
- Path to more sophistication

**Migration Paths:**
- Note components that might become agents
- Identify extraction opportunities
- Document potential refactoring

## Output Structure

Generate complete skill package:

```
my-custom-skill/
├── SKILL.md                 # Main skill definition
├── sample_prompt.md         # Copy-paste examples
├── HOW_TO_USE.md           # Usage guide (if complex)
├── scripts/                 # Python scripts (if needed)
│   ├── main.py
│   └── utils.py
└── test_data/              # Sample data (if applicable)
    └── sample.csv
```

## Integration with Validation

Before finalizing, validate:
- Syntax correctness
- Context alignment
- Complexity appropriateness
- Pattern consistency
- Terminology alignment

Use validation framework for comprehensive checks.

## Iterative Refinement

Support refinement through conversation:

"This is great, but can we add email notifications?"

→ Analyze new requirement
→ Determine integration approach
→ Update skill coherently
→ Maintain existing patterns

## Success Criteria

A successful skill:
- Solves the user's specific need
- Matches their technical capability
- Uses their terminology
- Fits their workflow
- Appropriate quality level
- Evolution-ready architecture

Every skill should feel like it was made specifically for that user - because it was.
