# Changelog

All notable changes to Toliss_ParkBrake_Proper are documented here.

## [1.4] — 2026-05-30

### Changed
- **ICAO lookup**: Converted from long OR chain to hash table. Adding aircraft support now requires a single-line table entry instead of modifying boolean logic.
- **Code simplification**: Simplified 5-line if/else block to Lua idiom (`button(...) and 1 or 0`)
- **Comment cleanup**: Trimmed redundant function comments; kept only essential scheduling information

### Why
- ICAO table is more maintainable and makes future aircraft additions straightforward
- Idiomatic Lua reduces code footprint without changing behavior
- Comments now explain the "why" of scheduling, not the "what" that the code already shows

## [1.3] — 2026-03-15

### Changed
- **Scheduler optimization**: Moved from `do_sometimes()` (~10 second intervals) to `do_often()` (~1 second intervals) for near real-time lever response
- Maintains all other optimizations from v1.2 (aircraft check at script load, ground/speed conditions)
- Cockpit now reflects lever position within ~1 second of physical movement — perceptible improvement in responsiveness

### Why
- v1.2's 10-second polling felt sluggish in normal use
- v1.3's 1-second interval provides responsive lever feedback while retaining minimal CPU overhead
- Still avoids per-frame work; script does nothing when airborne or at speed

## [1.2] — 2026-03-10

### Changed
- **Scheduling model**: Replaced per-frame polling with `do_sometimes()` callback (~10 second intervals)
- Aircraft ICAO check moved to script load time (runs once per aircraft change) instead of every frame
- Introduced ground/speed condition checks (on ground AND groundspeed < 5 m/s) to avoid unnecessary polling

### Why
- v1.1's per-frame polling added overhead to every rendered frame
- v1.2 eliminates unnecessary work: only polls when parking brake is operationally meaningful
- Aircraft check at load time is more efficient than every-frame checks

### Performance
- Reduced CPU overhead significantly compared to v1.1
- Script is silent when airborne or taxiing at speed

## [1.1] — 2026-03-05

### Changed
- Introduced adaptive scheduling based on flight state (ground vs. airborne, speed conditions)
- Proper aircraft ICAO validation to avoid interfering with non-ToLiss aircraft

### Why
- v1.0's simple approach worked but needed optimization for better simulator performance

## [1.0] — 2026-03-01

### Added
- Initial release
- FlyWithLua script mapping TCA parking brake lever to ToLiss `AirbusFBW/ParkBrake` dataref
- Per-frame polling of button state
- Support for 7 ToLiss Airbus variants (A319, A320, A20N, A21N, A321, A339, A346)
- Diagnostic script for finding system-specific button index
- Comprehensive user documentation (PDF)

### How It Solves the Problem
- Reads physical lever state every frame via FlyWithLua's `button()` function
- Directly writes sustained value (1/0) to ToLiss dataref instead of using X-Plane's command system
- Bypasses the fundamental mismatch between single-button hardware and discrete-command software

### Known Limitation
- Button index varies by system (depends on connected USB devices and enumeration order)
- Defaults to 19 (author's system); users may need to discover their index via diagnostic script
