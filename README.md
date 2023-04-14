# Record Raw Vehicle Data

Records vehicle coordinates, orientation, steering, etc each frame.
Results are saved automatically when recording is stopped.

Data is saved in both CSV and JSON format.

Works in TM2020 and MP4 (once the next MP4 version of Openplanet is released)

### Currently Saved Data (each frame)

* `vec3 Position`
* `vec3 Left`
* `vec3 Up`
* `vec3 Dir`
* `vec3 WorldVel`
* `vec3 WorldCarUp` *(TM2020 only)*
* `bool IsGroundContact`
* `bool IsWheelsBurning` *(TM2020 only)*
* `bool IsReactorGroundMode` *(TM2020 only)*
* `uint CurGear`
* `float FrontSpeed`
* `float InputSteer`
* `float InputGasPedal`
* `float InputBrakePedal`
* `float FLSteerAngle`
* `float FLWheelRot`
* `float FLWheelRotSpeed`
* `float FLDamperLen`
* `float FLSlipCoef`
* `float FRSteerAngle`
* `float FRWheelRot`
* `float FRWheelRotSpeed`
* `float FRDamperLen`
* `float FRSlipCoef`
* `float RLSteerAngle`
* `float RLWheelRot`
* `float RLWheelRotSpeed`
* `float RLDamperLen`
* `float RLSlipCoef`
* `float RRSteerAngle`
* `float RRWheelRot`
* `float RRWheelRotSpeed`
* `float RRDamperLen`
* `float RRSlipCoef`

Gathered from [CSceneVehicleVisState](https://next.openplanet.dev/Scene/CSceneVehicleVisState) via [VehicleState](https://openplanet.dev/docs/reference/vehiclestate).
Additional fields can be added on request.

-------

License: Public Domain

Authors: XertroV

Suggestions/feedback: @XertroV on Openplanet discord

Code/issues: [https://github.com/XertroV/tm-record-vehicle-data-raw](https://github.com/XertroV/tm-record-vehicle-data-raw)

GL HF
