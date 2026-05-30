# tcaxpbrake-commit

Stages files, creates a commit with proper issue reference, and pushes the feature branch to GitHub.

## Usage

```
/tcaxpbrake-commit <issue-number> "<commit-message>"
```

**Example:**
```
/tcaxpbrake-commit 5 "Improve ICAO lookup performance with lookup table"
```

## What It Does

1. Validates the current branch is a KB1SLN feature branch
2. Stages relevant files (you approve what gets staged)
3. Creates a commit with message format: `Fixes KB1SLN-5: <your-message>`
4. Pushes the branch to GitHub
5. Reports the commit hash and branch push

## Parameters

- `<issue-number>` — The KB1SLN issue number (5 for KB1SLN-5)
- `<commit-message>` — Clear, concise description of what changed and why

## Commit Message Format

The skill automatically formats commits as:
```
Fixes KB1SLN-5: Improve ICAO lookup performance with lookup table

Co-Authored-By: Claude Haiku 4.5 <noreply@anthropic.com>
```

The issue number links the commit to the Linear issue automatically.

## Output

- ✅ Files staged
- ✅ Commit created with issue reference
- ✅ Branch pushed to GitHub
- Commit hash and push confirmation

## When to Use

Use this skill **after implementation is complete and tested**:
1. You've made changes
2. You've verified they work (manually or via tests)
3. You're ready to push to GitHub

## After Commit

Once your branch is pushed, use `tcaxpbrake-finish` to:
- Merge to main
- Bump version
- Create git tag
- Push releases
