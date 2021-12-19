# luke_garages

This resource now only supports ESX Legacy, other versions of the framework **will not** work without modifying the resource.

Alongside cars, aircrafts and boats are also fully supported with them having their own separate garages and impounds.

The impound has checks in place to prevent vehicle duping.

I used esx_vehicleshop, but the resource should work with anything that follows that databse structure in `owned_vehicles` table.

[Updated Video Showcase](https://www.youtube.com/watch?v=GT2u5uoz7Tc)

### Dependencies

- [PolyZone](https://github.com/mkafrin/PolyZone)
- [qtarget](https://github.com/QuantusRP/qtarget)
- [nh-context](https://github.com/LukeWasTakenn/nh-context) - Since the original nh-context was removed, this is a link to my fork that should be the same as the original. Any fork version that's the same as original will work fine.
- Server game build 1868 or newer\*

Make sure to follow the well detailed installation instructions on qtarget.

### Installation

- Download the resource from releases
- Rename folder to luke_garages
- Drop the luke_garages folder into your resources folder
- Import the .sql file into your database
- Start the resource in your server.cfg

If you wish to add more garages or impounds make sure to follow the provided template and examples in the config.lua file.

Custom vehicles are now fully supported, for each custom vehicle you have to add a text entry of it's model and make name (if there isn't one already) into the vehicle_names.lua file which is located in the client folder. I provided an example of this that I used on the GTR in the video.

For any issues or bugs that may occur please open an Issue in the repository. Make sure to describe the issue in detail and how to reproduce it.

PRs are always welcome.

## Setting the game build

\*_Setting the game build is required due to the use of GetMakeNameFromVehicleModel native which was introduced in the game version 1868. If (for whatever reason) you don't want to change from the base build that FiveM comes with, you can remove all the appearances of this native and it's variables from the client file. Otherwise your game will be consistently crashing when trying to open either the garage or the impound._

There are two way sto set your game build:

1. Setting the build in your server.cfg
2. Setting the build in your launch params

Both methods work exactly the same, if you are setting your game build through launch params you will need to add a `+` in front of the command, otherwise you don't need to.

The command you need to use is: `set sv_enforceGameBuild` (example: `set sv_enforceGameBuild 2189`)

Depending on the game build number you choose is the GTA DLC your server is going to be running:

```
1604 - Vanilla
2060 - Casino Heist
2189 - Cayo Perico Heist
2373 - Tuners update
```
