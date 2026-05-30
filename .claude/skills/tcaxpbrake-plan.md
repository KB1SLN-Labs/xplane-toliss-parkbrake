# tcaxpbrake-plan

Creates a grounded implementation plan for non-trivial work. Use this skill when the issue scope is complex or when you're unsure of the approach.

## Usage

```
/tcaxpbrake-plan <issue-number>
```

**Example:**
```
/tcaxpbrake-plan 5
```

## What It Does

1. Fetches the Linear issue (KB1SLN-5)
2. Reads current project code state
3. Explores existing patterns and architecture
4. Designs a concrete implementation approach
5. Creates a detailed plan with:
   - Context and why the change is needed
   - Specific files to modify
   - Implementation steps
   - Verification/testing approach

## Parameters

- `<issue-number>` — The KB1SLN issue number

## Output

- Detailed implementation plan
- Critical files identified
- Step-by-step execution strategy
- Testing/verification approach

## When to Use

Use this skill for:
- **Non-trivial features** — Anything more complex than a simple bug fix
- **Architectural changes** — When the approach isn't obvious
- **Refactoring** — When multiple files are involved
- **When uncertain** — If you're not sure how to approach the work

For simple one-line fixes or typos, you can skip this and go straight to implementation.

## After Planning

Once the plan is approved, proceed to:
1. Implement changes per the plan
2. Test thoroughly
3. Use `tcaxpbrake-commit` to stage and commit
4. Use `tcaxpbrake-finish` to merge and release
