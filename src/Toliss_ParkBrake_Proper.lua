-- =============================================================================
-- Toliss_ParkBrake_Proper.lua
-- =============================================================================
-- Author:      Chris McKenna
-- Contact:     kb1sln@gmail.com
-- Version:     1.3
-- Date:        March 2026
-- Simulator:   X-Plane 12
-- Aircraft:    ToLiss A319, A320, A20N, A21N, A321, A339, A346
-- Hardware:    Thrustmaster TCA Quadrant Airbus Edition (with or without Add-On)
-- =============================================================================
--
-- DESCRIPTION:
--   This script correctly maps the Thrustmaster TCA Quadrant parking brake
--   lever to the ToLiss Airbus parking brake dataref (AirbusFBW/ParkBrake).
--
-- THE PROBLEM THIS SOLVES:
--   The TCA parking brake lever communicates with the PC as a single virtual
--   button. When the lever is in the SET position that button is held; when
--   released to PARK BRK it is simply not held. There is no separate "brake
--   off" button.
--
--   X-Plane's native binding system fires discrete command events at the
--   moment a button transitions. The ToLiss parking brake dataref expects a
--   sustained value (1=on, 0=off). These two models are incompatible with a
--   single-button source, which is why a FlyWithLua script is required.
--
-- HOW IT WORKS (v1.3 — Near Real-Time Response):
--   The script uses two mechanisms, each running at exactly the right
--   frequency:
--
--   Script load (top-level code):
--     FlyWithLua reloads all scripts automatically whenever the aircraft
--     changes. Top-level Lua code -- code outside any function -- runs
--     exactly once at that point. The ICAO check is performed at this
--     level, setting a boolean flag (is_toliss) once per aircraft load.
--     If the loaded aircraft is not a supported ToLiss type, the flag is
--     false and nothing else in the script ever runs for that session.
--     The ICAO string is never read again after this point.
--
--   do_often() (~every 1 second):
--     If is_toliss is true, checks whether the aircraft is on the ground
--     with groundspeed below 5 m/s. If both conditions are met, reads the
--     physical lever state and writes it to AirbusFBW/ParkBrake. If either
--     condition is not met (airborne, or at speed), does nothing.
--     The ~1 second interval provides near real-time lever response with
--     no per-frame overhead. In normal use the cockpit will reflect the
--     lever position within approximately 1 second of it being moved.
--
--   SCHEDULING NOTE:
--     do_often() fires on an "at or after" basis -- 1 second is a minimum
--     interval, not a guarantee. Under high simulator load the actual
--     interval may stretch slightly beyond 1 second. For a parking brake
--     this is imperceptible in normal use.
--
-- DATAREFS USED:
--   AirbusFBW/ParkBrake                        writable  int    1=ON  0=OFF
--   sim/aircraft/view/acf_ICAO                 readonly  string ICAO code
--   sim/flightmodel/failures/onground_any      readonly  int    1=on ground
--   sim/flightmodel/position/groundspeed       readonly  float  m/s
--
-- REQUIREMENTS:
--   1. X-Plane 12
--   2. FlyWithLua NG (Next Generation) plugin for X-Plane 12
--      https://forums.x-plane.org/index.php?/files/file/82888-flywithlua-ng-next-generation-edition-for-x-plane-12/
--   3. Thrustmaster TCA Quadrant Airbus Edition
--   4. Virtual buttons MUST be enabled in Windows:
--        Start > "Set up USB game controllers" > TCA Q-Eng 1&2 >
--        Properties > check "Enable virtual buttons" > Apply
--   5. ToLiss A319, A320, A320neo, A321, A321neo, A330-900, or A340-600
--
-- INSTALLATION:
--   1. Copy this file to:
--        <X-Plane 12>/Resources/plugins/FlyWithLua/Scripts/
--   2. In X-Plane 12 Joystick settings find the parking brake button
--      and set it to "Do nothing" (prevents binding conflicts)
--   3. Plugins > FlyWithLua > Reload all Lua script files
--   4. Push the lever to SET -- within approximately 1 second the cockpit
--      lever should move and the PARK BRK annunciator should illuminate
--
-- FINDING YOUR BUTTON NUMBER:
--   The index 19 below is correct for the author's system. It may differ
--   on yours depending on connected devices. To find your number:
--
--     function ShowButtonNumber()
--         for i = 0, 1599 do
--             if button(i) then logMsg("BTN: " .. i) end
--         end
--     end
--     do_every_frame("ShowButtonNumber()")
--
--   Save as a separate .lua file, reload FlyWithLua, push the lever,
--   check Log.txt for "BTN:" lines. Update PARK_BRAKE_BUTTON below with
--   that number, then remove the diagnostic script.
--
-- SUPPORTED AIRCRAFT ICAO CODES:
--   A319  ToLiss Airbus A319
--   A320  ToLiss Airbus A320
--   A20N  ToLiss Airbus A320neo
--   A21N  ToLiss Airbus A321neo
--   A321  ToLiss Airbus A321
--   A339  ToLiss Airbus A330-900
--   A346  ToLiss Airbus A340-600
--
-- CHANGES FROM v1.2:
--   - Scheduler changed from do_sometimes() (~10 seconds) to do_often()
--     (~1 second). This provides near real-time lever response while
--     retaining all other optimisations from v1.2. The ICAO check still
--     runs once at script load time. No per-frame work is performed.
--     The 1-second interval is imperceptible in normal use -- the cockpit
--     will reflect the lever position before the pilot has looked at the
--     annunciator panel.
--
-- LICENSE:
--   Freeware. Free to use, modify, and redistribute.
--   Credit appreciated but not required.
-- =============================================================================

dataref("TL_ParkBrake",  "AirbusFBW/ParkBrake",                        "writable")
dataref("PLANE_ICAO",    "sim/aircraft/view/acf_ICAO",                  "readonly")
dataref("ON_GROUND",     "sim/flightmodel/failures/onground_any",       "readonly")
dataref("GROUND_SPEED",  "sim/flightmodel/position/groundspeed",        "readonly")

-- Global FlyWithLua button index for the TCA parking brake lever.
-- X-Plane 12 joystick UI showed button 14 on Chris's system, but
-- FlyWithLua uses a global 0-based index including per-device offset.
-- Confirmed as 19 via diagnostic script. Change if your system differs.
local PARK_BRAKE_BUTTON = 19

-- Groundspeed threshold in m/s. Below this value (on the ground) the
-- script syncs the lever state. At or above this value it does nothing.
-- 5 m/s (~10 kt) is well above any speed at which parking brakes are
-- applied; increasing this value is not recommended.
local SPEED_THRESHOLD = 5.0

-- Evaluated once at script load time.
-- FlyWithLua reloads all scripts when the aircraft changes, so this
-- executes exactly once per aircraft load -- equivalent to the intended
-- do_on_aircraft_load() behaviour without requiring that function.
-- True if the loaded aircraft is a supported ToLiss type.
-- If false, TCA_ParkBrake_Update() returns immediately and does no work.
local is_toliss = false
do
    if PLANE_ICAO ~= nil then
        local icao = string.upper(tostring(PLANE_ICAO))
        is_toliss = (icao == "A319" or icao == "A320" or icao == "A20N" or
                     icao == "A21N" or icao == "A321" or icao == "A339" or icao == "A346")
    end
end

-- Runs approximately every 1 second via do_often().
-- If is_toliss is false, returns immediately -- no work done.
-- If the aircraft is on the ground and groundspeed is below the threshold,
-- reads the physical lever state and writes it to AirbusFBW/ParkBrake.
-- If airborne or at speed, returns immediately -- no work done.
-- The ~1 second interval provides near real-time response with no
-- per-frame overhead.
function TCA_ParkBrake_Update()
    if not is_toliss then return end
    if ON_GROUND == 1 and GROUND_SPEED < SPEED_THRESHOLD then
        if button(PARK_BRAKE_BUTTON) then
            TL_ParkBrake = 1
        else
            TL_ParkBrake = 0
        end
    end
end

do_often("TCA_ParkBrake_Update()")
