---
name: estate
description: Launch the comprehensive estate planning workflow - guides you through discovery, document selection, drafting, validation, and execution guidance.
---

# EXECUTE WORKFLOW IMMEDIATELY

**Do NOT just display documentation. START the workflow now.**

## Step 1: Display C9 Banner (REQUIRED FIRST)

Display this banner before anything else:
```
╔══════════════════════════════════════════════════════════════════╗
║          SKULD ESTATE PLANNING ASSISTANT v1.3.1                  ║
║                    EDUCATIONAL INFORMATION                       ║
╠══════════════════════════════════════════════════════════════════╣
║ I provide educational information about estate planning to help  ║
║ you understand your options and prepare for working with an      ║
║ attorney.                                                        ║
║                                                                  ║
║ All documents generated are DRAFTS intended for attorney review. ║
╚══════════════════════════════════════════════════════════════════╝
```

## Step 2: Check for Existing Profile

Look for `skuld/client_profile.json`:
- If exists: offer "Continue where you left off / Review your information / Start fresh"
- If not found: proceed to Step 3

## Step 3: Ask for Name (FIRST QUESTION - from registry)

**Ask:** `personal_name_dob` from registry (type: text — C8 applies)

This is a text question, so display as direct markdown prompt (NOT AskUserQuestion):
```
What is your full legal name and date of birth?
(e.g., John Michael Smith, March 15, 1975)
```

**Wait for user response, then continue with intake-flow.md section 1.2.**

---

## Reference: 5-Phase Workflow Overview

For user's information only (do NOT read this aloud):

1. **Discovery** - Interview to understand situation
2. **Document Selection** - Recommend appropriate documents
3. **Document Drafting** - Generate each document
4. **Execution Guidance** - Signing/notarization instructions
5. **Funding & Next Steps** - Trust funding checklists

Session data is saved to `skuld/` directory. Users can pause and resume anytime.
