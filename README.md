# Toliss_ParkBrake_Proper

A FlyWithLua script that correctly maps the Thrustmaster TCA Quadrant parking brake lever to ToLiss Airbus aircraft in X-Plane 12.

## The Problem

The TCA parking brake lever communicates with X-Plane as a single virtual button. X-Plane's native binding system fires discrete commands on button transitions, but the ToLiss parking brake dataref expects a sustained value (1=ON, 0=OFF). These two models are incompatible, resulting in the brake toggling momentarily and immediately releasing.

This script solves that mismatch.

## Quick Start

### Requirements

- **X-Plane 12**
- **FlyWithLua NG** plugin ([download](https://forums.x-plane.org/index.php?/files/file/82888-flywithlua-ng-next-generation-edition-for-x-plane-12/))
- **Thrustmaster TCA Quadrant Airbus Edition**
- **Virtual buttons enabled in Windows** (see Installation)
- **ToLiss Airbus** (A319, A320, A20N, A21N, A321, A339, or A346)

### Installation

1. **Enable virtual buttons in Windows:**
   - Press Start, type `joy`
   - Click "Set up USB game controllers"
   - Double-click "TCA Q-Eng 1&2"
   - Click "Properties"
   - Check "Enable virtual buttons"
   - Click Apply, then OK

2. **Copy the script:**
   - Copy `Toliss_ParkBrake_Proper.lua` to: `<X-Plane 12>/Resources/plugins/FlyWithLua/Scripts/`

3. **Clear X-Plane bindings:**
   - In X-Plane 12, go to Settings > Joystick
   - Find your TCA device and locate the parking brake button
   - Click Edit and set it to "Do nothing"

4. **Reload FlyWithLua:**
   - In X-Plane, go to Plugins > FlyWithLua > Reload all Lua script files

5. **Test:**
   - Load a supported ToLiss aircraft
   - Push the parking brake lever to SET
   - The cockpit lever should move and the PARK BRK annunciator should illuminate

### Finding Your Button Number

The script defaults to button 19, which is correct for a typical TCA + sidestick setup. If it doesn't work on your system, your button index may differ.

Use the diagnostic script in the `tools/` folder:

1. Copy `ParkBrake_Debug.lua` to your FlyWithLua Scripts folder
2. Reload FlyWithLua scripts
3. Load a ToLiss aircraft
4. Push the parking brake lever to SET and hold it
5. Open `<X-Plane 12>/Log.txt` and search for `BTN:`
6. The number shown is your button index
7. Update `PARK_BRAKE_BUTTON` in the main script with that number
8. Delete `ParkBrake_Debug.lua` and reload FlyWithLua

## Supported Aircraft

| ICAO | Aircraft |
|------|----------|
| A319 | ToLiss Airbus A319 |
| A320 | ToLiss Airbus A320 |
| A20N | ToLiss Airbus A320neo |
| A21N | ToLiss Airbus A321neo |
| A321 | ToLiss Airbus A321 |
| A339 | ToLiss Airbus A330-900 |
| A346 | ToLiss Airbus A340-600 |

## How It Works

The script uses FlyWithLua's scheduled polling (~1 second via `do_often()`) to:

1. Check if the loaded aircraft is a supported ToLiss type
2. Check if the aircraft is on the ground with groundspeed below 5 m/s
3. Read the physical lever state via FlyWithLua's `button()` function
4. Write that state directly to the ToLiss `AirbusFBW/ParkBrake` dataref

The cockpit lever stays in perfect sync with the physical lever with near-real-time response (~1 second).

## Troubleshooting

**Nothing happens when I move the lever:**
- Verify virtual buttons are enabled in Windows (see Installation step 1)
- Run the diagnostic script to confirm your button number
- Confirm FlyWithLua was reloaded

**The brake sets but immediately releases:**
- Confirm you cleared the X-Plane joystick binding (Installation step 3)
- Check for other parking brake Lua scripts in your FlyWithLua Scripts folder and remove them

**The script works on one ToLiss aircraft but not another:**
- The aircraft's ICAO code may not be in the supported list
- Open the X-Plane developer console (Special menu) to check the ICAO code
- Contact the project if you'd like support added

## Full Documentation

See [docs/Toliss_ParkBrake_Proper_Documentation.pdf](docs/Toliss_ParkBrake_Proper_Documentation.pdf) for comprehensive documentation including hardware details, installation steps, troubleshooting, and more.

## License

Free to use, modify, and distribute. Credit appreciated but not required.

See [LICENSE](LICENSE) for details.

## Contributing

Found a bug? Want to add support for a new ToLiss aircraft? Open an issue or contact the author.

**Author:** Chris McKenna  
**Email:** kb1sln@gmail.com
