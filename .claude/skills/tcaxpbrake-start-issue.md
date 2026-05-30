# tcaxpbrake-start-issue

Fetches a Linear issue from KB1SLN-Labs/XP-Thrustmaster-ParkBrake project, verifies scope, creates a feature branch, and summarizes context for implementation.

## Usage

```
/tcaxpbrake-start-issue <issue-number>
```

**Example:**
```
/tcaxpbrake-start-issue 5
```

## What It Does

1. Fetches issue KB1SLN-5 from Linear
2. Verifies the issue belongs to XP-Thrustmaster-ParkBrake project
3. Creates a feature branch: `feature/kb1sln-5-{slug}`
4. Summarizes issue scope, acceptance criteria, and context
5. Reports ready to start work

## Parameters

- `<issue-number>` — The KB1SLN issue number (e.g., 5 for KB1SLN-5)

## Output

- ✅ Feature branch created and checked out
- Summary of issue details (title, description, labels)
- Any blocking issues or dependencies
- Ready for implementation

## When to Use

Run this **first** when starting work on any KB1SLN-Labs issue. It ensures:
- You're working on an issue that exists
- You have a clean feature branch
- You understand the scope before coding
