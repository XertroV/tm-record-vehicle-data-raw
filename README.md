# Record Raw Vehicle Data

Records vehicle coordinates, orientation, steering, etc each frame.
Results are saved automatically when recording is stopped.

### Currently Saved Data (each frame)

* `vec3 Position`
* `vec3 Left`
* `vec3 Up`
* `vec3 Dir`
* `vec3 WorldVel`
* `vec3 WorldCarUp`
* `bool IsGroundContact`
* `bool IsWheelsBurning`
* `bool IsReactorGroundMode`
* `uint CurGear`
* `float FrontSpeed`
* `float InputSteer`
* `float InputGasPedal`
* `float InputBrakePedal`

-------

License: Public Domain

Authors: XertroV

Suggestions/feedback: @XertroV on Openplanet discord

Code/issues: [https://github.com/XertroV/tm-record-vehicle-data-raw](https://github.com/XertroV/tm-record-vehicle-data-raw)

GL HF
