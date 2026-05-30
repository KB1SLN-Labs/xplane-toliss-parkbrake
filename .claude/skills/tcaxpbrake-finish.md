# tcaxpbrake-finish

Final step: merges the feature branch to main, bumps version/date, updates CHANGELOG, creates a git tag, pushes to GitHub, and moves the Linear issue to Done.

## Usage

```
/tcaxpbrake-finish <issue-number>
```

**Example:**
```
/tcaxpbrake-finish 5
```

## What It Does

1. Verifies the feature branch is clean (all changes committed)
2. Switches to main and pulls latest
3. Merges feature branch into main
4. Bumps version in script header and updates date
5. Updates CHANGELOG.md with release notes
6. Creates annotated git tag (vX.Y.Z)
7. Pushes main and tag to GitHub
8. Moves Linear issue KB1SLN-5 to Done status

## Parameters

- `<issue-number>` — The KB1SLN issue number

## Version Bumping Strategy

- **Patch bump** (1.4 → 1.4.1) — Bug fixes, minor improvements
- **Minor bump** (1.4 → 1.5) — New features, non-breaking changes
- **Major bump** (1.4 → 2.0) — Breaking changes, major refactors

The skill will ask you to confirm the version bump before proceeding.

## Output

- ✅ Branch merged to main
- ✅ Version bumped and documented
- ✅ CHANGELOG updated
- ✅ Git tag created and pushed
- ✅ Linear issue moved to Done
- Release tag and version number

## When to Use

Use this skill **only after**:
1. Feature branch is complete and pushed
2. You've tested the changes
3. Commit has been created with `tcaxpbrake-commit`
4. You're ready to release to production

## After Finish

The issue is now:
- Merged to main
- Released with a version tag
- Documented in CHANGELOG
- Closed in Linear

Users can now pull the latest changes or install the release from GitHub.
