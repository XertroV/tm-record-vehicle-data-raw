// per frame
array<VehiclePosition@> positions;

// fix intellisense
#if false
array positions;
#endif

string LastRecordedMap = "";

void OnRecordingToggle() {
    if (g_currentlySavingRecording) return;  // don't do anything if we're saving
    bool wasRecording = g_isRecording;
    g_isRecording = !g_isRecording;
    if (wasRecording)
        SaveData(); // blocks & yields to avoid performance impact
    else
        LastRecordedMap = GetMapName();
    // reset positions array after saving
    positions.RemoveRange(0, positions.Length);
}

void RecordPosition() {
    positions.InsertLast(VehiclePosition());
}

class VehiclePosition {
    uint ts;
    vec3 Position;
    vec3 Left;
    vec3 Up;
    vec3 Dir;
    vec3 WorldVel;
    vec3 WorldCarUp;
    bool IsGroundContact;
    bool IsWheelsBurning;
    bool IsReactorGroundMode;
    uint CurGear;
    float FrontSpeed;
    float InputSteer;
    float InputGasPedal;
    float InputBrakePedal;

    VehiclePosition() {
        ts = Time::Now;
        PopulatePositionInfo();
    }

    private void PopulatePositionInfo() {
        auto vs = VehicleState::ViewingPlayerState();
        if (vs is null) return;
        Position = vs.Position;
        Left = vs.Left;
        Up = vs.Up;
        Dir = vs.Dir;
        WorldVel = vs.WorldVel;
        WorldCarUp = vs.WorldCarUp;
        IsGroundContact = vs.IsGroundContact;
        IsWheelsBurning = vs.IsWheelsBurning;
        IsReactorGroundMode = vs.IsReactorGroundMode;
        CurGear = vs.CurGear;
        FrontSpeed = vs.FrontSpeed;
        InputSteer = vs.InputSteer;
        InputGasPedal = vs.InputGasPedal;
        InputBrakePedal = vs.InputBrakePedal;
    }

    const string ToRowString() {
        string ret = "";
        ret += tostring(ts) + ", ";
        ret += Vec3ToRS(Position) + ", ";
        ret += Vec3ToRS(Left) + ", ";
        ret += Vec3ToRS(Up) + ", ";
        ret += Vec3ToRS(Dir) + ", ";
        ret += Vec3ToRS(WorldVel) + ", ";
        ret += Vec3ToRS(WorldCarUp) + ", ";
        ret += (IsGroundContact ? "true" : "false") + ", ";
        ret += (IsWheelsBurning ? "true" : "false") + ", ";
        ret += (IsReactorGroundMode ? "true" : "false") + ", ";
        ret += tostring(CurGear) + ", ";
        ret += tostring(FrontSpeed) + ", ";
        ret += tostring(InputSteer) + ", ";
        ret += tostring(InputGasPedal) + ", ";
        ret += tostring(InputBrakePedal); // + ", ";
        return ret;
    }

    Json::Value ToJson() {
        auto ret = Json::Object();
        ret["Time"] = tostring(ts);  // avoid json saving in scientific notation above 10,000
        ret["Position"] = Vec3ToJson(Position);
        ret["Left"] = Vec3ToJson(Left);
        ret["Up"] = Vec3ToJson(Up);
        ret["Dir"] = Vec3ToJson(Dir);
        ret["WorldVel"] = Vec3ToJson(WorldVel);
        ret["WorldCarUp"] = Vec3ToJson(WorldCarUp);
        ret["IsGroundContact"] = IsGroundContact;
        ret["IsWheelsBurning"] = IsWheelsBurning;
        ret["IsReactorGroundMode"] = IsReactorGroundMode;
        ret["CurGear"] = CurGear;
        ret["FrontSpeed"] = FrontSpeed;
        ret["InputSteer"] = InputSteer;
        ret["InputGasPedal"] = InputGasPedal;
        ret["InputBrakePedal"] = InputBrakePedal;
        return ret;
    }
}

const string Vec3ToRS(vec3 v) {
    return "(" + string::Join({tostring(v.x), tostring(v.y), tostring(v.z)}, ", ") + ")";
}
Json::Value Vec3ToJson(vec3 v) {
    auto ret = Json::Array();
    ret.Add(v.x);
    ret.Add(v.y);
    ret.Add(v.z);
    return ret;
}

const array<string> DataColumnNames = {
    "Time",
    "Position",
    "Left",
    "Up",
    "Dir",
    "WorldVel",
    "WorldCarUp",
    "IsGroundContact",
    "IsWheelsBurning",
    "IsReactorGroundMode",
    "CurGear",
    "FrontSpeed",
    "InputSteer",
    "InputGasPedal",
    "InputBrakePedal"
};

const string DataHeaderRow = string::Join(DataColumnNames, ", ");
