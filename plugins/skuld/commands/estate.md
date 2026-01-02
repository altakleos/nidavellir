---
name: estate
description: Launch the comprehensive estate planning workflow - guides you through discovery, document selection, drafting, validation, and execution guidance.
---

# Estate Planning Workflow

This command launches the full 5-phase estate planning workflow.

## What Happens When You Run /estate

1. **Welcome & Discovery** - I'll display educational context, check for existing profiles, and conduct an interview to understand your situation (family, assets, goals, state of residence).

2. **Document Selection** - Based on your situation, I'll recommend appropriate documents (trust, will, POA, healthcare directive) and explain what each does.

3. **Document Drafting** - I'll generate each document with your specific information, presenting drafts for your approval before saving.

4. **Execution Guidance** - I'll provide state-specific instructions for signing, witnessing, and notarizing your documents.

5. **Funding & Next Steps** - I'll create checklists for trust funding and ongoing maintenance.

## Time Commitment

A complete estate planning session typically takes:

| Phase | Estimated Time |
|-------|----------------|
| Discovery (interview) | 15-30 minutes |
| Document Selection | 10-15 minutes |
| Document Drafting | 30-60 minutes |
| Execution Guidance | 10-15 minutes |
| Funding Checklist | 10-15 minutes |
| **Total** | **75-135 minutes** |

**Note:** You can pause at any point and resume later - even days or weeks later. Your progress is automatically saved. Complex situations (blended families, special needs planning, business interests) may take longer.

## Before You Begin

Have the following information ready:
- Full legal names (you and spouse if married)
- State of residence
- Children's names and birth dates (if any)
- General idea of assets (real estate states, retirement accounts, business interests)
- Who you'd want as:
  - Successor trustee (manages trust if you can't)
  - Executor (handles estate through probate)
  - Guardian (raises minor children if both parents pass)
  - Healthcare agent (makes medical decisions if you can't)
  - Financial agent (manages finances if incapacitated)

## Important Notice

All documents generated are **DRAFTS intended for attorney review**. I provide educational information to help you understand your options and prepare for working with an attorney.

## Resume Existing Session

Your progress is automatically saved throughout the workflow. You can stop at any time and resume another day - even weeks later.

**What gets saved:**
- All your answers from the discovery interview
- Which documents you selected
- Which documents have been generated
- Your current position in the workflow

**When you return:**
- I'll detect your existing profile and show a summary of your progress
- You can choose to: continue where you left off, review your information, or start fresh
- If it's been more than 30 days, I'll suggest reviewing your information (life changes may affect your plan)

**Session data locations:**
| Data | Location |
|------|----------|
| Your profile | `skuld/client_profile.json` |
| Draft documents | `skuld/drafts/` |
| Validation reports | `skuld/validation/` |
| Execution checklists | `skuld/execution/` |
| Funding guides | `skuld/funding/` |

**Cleanup options:**
At the end of the workflow, you can choose to:
- Keep everything for future updates
- Archive (keep documents, reset session state)
- Delete all working data

## Commands Within the Workflow

During the workflow, you can:
- Navigate by saying "go back to discovery" or "skip to drafting"
- Ask questions about any terms or concepts
- Request explanations of your options
- Review and modify your profile information

## Asking Questions During Interview

If you encounter unfamiliar terms during the interview (like "successor trustee" or "healthcare agent"), you can:
- Select "I have a question about this" if that option appears
- Type your question in the "Other" field
- Simply ask "What does [term] mean?"

I'll provide an educational explanation and then return to the question so you can answer with confidence.
