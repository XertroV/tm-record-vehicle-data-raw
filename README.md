# Record Raw Vehicle Data

Records vehicle coordinates, orientation, steering, etc each frame.
Results are saved automatically when recording is stopped.

Data is saved in both CSV and JSON format.

Works in TM2020 and MP4 (from version 0.2 onwards)

### Currently Saved Data (each frame)

* `vec3 Position`
* `vec3 Left` *(TM2020 only)*
* `vec3 Up` *(TM2020 only)*
* `vec3 Dir` *(TM2020 only)*
* `vec3 WorldVel`
* `vec3 WorldCarUp` *(TM2020 only)*
* `bool IsGroundContact` *(TM2020 only)*
* `bool IsWheelsBurning` *(TM2020 only)*
* `bool IsReactorGroundMode` *(TM2020 only)*
* `uint CurGear`
* `float FrontSpeed`
* `float InputSteer`
* `float InputGasPedal`
* `float InputBrakePedal`

Gathered from [CSceneVehicleVisState](https://next.openplanet.dev/Scene/CSceneVehicleVisState) via [VehicleState](https://openplanet.dev/docs/reference/vehiclestate).
Additional fields can be added on request (e.g., could add data for wheels with a toggle in settings)

-------

License: Public Domain

Authors: XertroV

Suggestions/feedback: @XertroV on Openplanet discord

Code/issues: [https://github.com/XertroV/tm-record-vehicle-data-raw](https://github.com/XertroV/tm-record-vehicle-data-raw)

GL HF
