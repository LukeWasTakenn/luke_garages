# luke_vehiclegarage

This resource now only supports ESX Legacy, other versions of the framework **will not** work without modifying the resource.

Alongside cars, aircrafts and boats are also fully supported with them having their own separate garages and impounds.

The impound has checks in place to prevent vehicle duping.

I used esx_vehicleshop, but the resource should work with anything that follows that databse structure in `owned_vehicles` table.

[Updated Video Showcase](https://www.youtube.com/watch?v=GT2u5uoz7Tc)

### Dependencies
* [PolyZone](https://github.com/mkafrin/PolyZone)
* [qtarget](https://github.com/QuantusRP/qtarget)
* [nh-context](https://github.com/nerohiro/nh-context)

Make sure to follow the well detailed installation instructions on qtarget.

### Installation
* Download the resource from releases
* Rename folder to luke_vehiclegarage
* Drop the luke_vehiclegarage folder into your resources folder
* Import the .sql file into your database
* Start the resource in your server.cfg

If you wish to add more garages or impounds make sure to follow the provided template and examples in the config.lua file.

Custom vehicles are now fully supported, for each custom vehicle you have to add a text entry of it's model and make name (if there isn't one already) into the vehicle_names.lua file which is located in the client folder. I provided an example of this that I used on the GTR in the video.

For any issues or bugs that may occur please open an Issue in the repository. Make sure to describe the issue in detail and how to reproduce it.

PRs are always welcome.
