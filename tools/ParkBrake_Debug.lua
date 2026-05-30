-- =============================================================================
-- ParkBrake_Debug.lua — Diagnostic Script
-- =============================================================================
-- PURPOSE:
--   Finds the FlyWithLua global button index for the TCA parking brake lever
--   on your specific system. The index varies by connected USB devices and
--   enumeration order.
--
-- HOW TO USE:
--   1. Copy this file to: <X-Plane 12>/Resources/plugins/FlyWithLua/Scripts/
--   2. In X-Plane 12, go to Plugins > FlyWithLua > Reload all Lua script files
--   3. Load a supported ToLiss aircraft
--   4. Push the parking brake lever to the SET position and hold it
--   5. Open <X-Plane 12>/Log.txt in a text editor
--   6. Search for lines starting with "BTN:" — the number on those lines
--      is your button index
--   7. Update PARK_BRAKE_BUTTON in Toliss_ParkBrake_Proper.lua with that number
--   8. DELETE THIS FILE from the Scripts folder
--   9. Reload FlyWithLua scripts
--
-- IMPORTANT:
--   This script writes to the log file on every frame while any button is held.
--   Remove it as soon as you have your number — leaving it running will cause
--   Log.txt to grow very rapidly and may slow X-Plane down.
-- =============================================================================

function ShowButtonNumber()
    for i = 0, 1599 do
        if button(i) then
            logMsg("BTN: " .. i)
        end
    end
end

do_every_frame("ShowButtonNumber()")
