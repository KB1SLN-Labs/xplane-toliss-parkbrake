# CLAUDE.md — Toliss_ParkBrake_Proper

## Project Overview

**Toliss_ParkBrake_Proper** is a FlyWithLua plugin script for X-Plane 12 that solves a hardware/software mismatch between the Thrustmaster TCA Quadrant parking brake lever and ToLiss Airbus aircraft.

**Status**: Production-ready. Being packaged as an official open-source GitHub project (separate from APT Commercial work).

**Current Version**: 1.3 (March 2026)

**Supported Aircraft**: ToLiss A319, A320, A20N, A21N, A321, A339, A346

## What It Does

Maps the physical state of the TCA parking brake lever to the ToLiss `AirbusFBW/ParkBrake` dataref using FlyWithLua's scheduled polling (~1 second via `do_often()`). This bypasses X-Plane's command system, which can't sustain the dataref value from a single-button source.

## Repository Structure

```
├── LICENSE                                  # MIT/freeware license
├── README.md                                # Quick-start guide
├── CHANGELOG.md                             # Version history (V1.0–V1.3)
├── CLAUDE.md                                # This file
├── .gitignore                               # Git ignore rules
├── docs/
│   └── Toliss_ParkBrake_Proper_Documentation.pdf    # Full user guide
├── src/
│   └── Toliss_ParkBrake_Proper.lua          # Main script (v1.3)
└── tools/
    └── ParkBrake_Debug.lua                  # Diagnostic script for button discovery
```

## Development Notes

### Code Style
- Lua (FlyWithLua dialect for X-Plane 12)
- Clear variable names, concise comments (explain "why," not "what")
- No defensive error handling for internal state (trust FlyWithLua/X-Plane)

### Versioning
- Semantic versioning (v1.0, v1.1, v1.2, v1.3, etc.)
- Main branch only for releases
- GitHub releases with tagged versions

### Aircraft Support
Adding support for a new aircraft:
1. Obtain its ICAO code from X-Plane
2. Verify it uses the same `AirbusFBW/ParkBrake` dataref
3. Add ICAO code to the aircraft check in the main script (line ~145 in v1.3)
4. Increment version (patch version bump if minor)
5. Update CHANGELOG.md and docs
6. Create a GitHub release

### Testing
- Manual testing in X-Plane 12 with physical TCA lever
- Verify lever sync speed (~1 second)
- Test on ground at speed < 5 m/s (operational condition)
- Test that script does nothing airborne or at speed ≥ 5 m/s

## Known Limitations

1. **Button index is system-dependent**: FlyWithLua uses a global 0-based button index that varies by connected input devices. Script defaults to 19 (author's system). Users must run diagnostic script to find their index if different.

2. **Requires virtual buttons enabled**: Windows must have "Enable virtual buttons" checked in TCA device properties. Without this, the lever doesn't register as a button.

3. **No conflict detection**: If X-Plane has an active binding on the same button, it conflicts with the script. Users must clear the binding manually.

4. **Ground/speed check is hardcoded**: The 5 m/s threshold and ground/speed conditions are not configurable. This is intentional — the parking brake is only meaningful at these conditions.

## Future Enhancements (Optional)

- Convert PDF documentation to Markdown for GitHub rendering
- Add issue templates for bug reports and aircraft support requests
- Create GitHub Pages site if community interest grows
- Consider expanding to other aircraft that use similar datarefs

## Governance Skills

This project uses 4 reusable skills to enforce Kanban workflow and version discipline:

1. **`tcaxpbrake-start-issue`** — Fetch Linear issue, create feature branch, summarize scope
2. **`tcaxpbrake-plan`** — Generate implementation plan (for non-trivial work)
3. **`tcaxpbrake-commit`** — Stage files, commit with issue reference, push branch
4. **`tcaxpbrake-finish`** — Merge to main, bump version, update CHANGELOG, tag, push

See `.claude/skills/` for detailed documentation of each skill.

### Typical Workflow

```
1. /tcaxpbrake-start-issue 5          # Create branch KB1SLN-5
2. [Implement changes]
3. /tcaxpbrake-plan 5                 # (optional: for complex work)
4. [Continue implementation]
5. /tcaxpbrake-commit 5 "message"     # Push feature branch
6. /tcaxpbrake-finish 5               # Merge, tag, release
```

## GitHub Repo

**Status**: Live and public at https://github.com/KB1SLN-Labs/xplane-toliss-parkbrake

**Releases**: All versions (v1.0–v1.4) available with tags. Releases created via `tcaxpbrake-finish` skill.

## Contact

**Author**: Chris McKenna  
**Email**: kb1sln@gmail.com  
**License**: Freeware (credit appreciated but not required)
