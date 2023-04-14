// per frame
array<VehiclePosition@> positions;

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
    float FLSteerAngle;
    float FLWheelRot;
    float FLWheelRotSpeed;
    float FLDamperLen;
    float FLSlipCoef;
    float FRSteerAngle;
    float FRWheelRot;
    float FRWheelRotSpeed;
    float FRDamperLen;
    float FRSlipCoef;
    float RLSteerAngle;
    float RLWheelRot;
    float RLWheelRotSpeed;
    float RLDamperLen;
    float RLSlipCoef;
    float RRSteerAngle;
    float RRWheelRot;
    float RRWheelRotSpeed;
    float RRDamperLen;
    float RRSlipCoef;

    VehiclePosition() {
        ts = Time::Now;
        PopulatePositionInfo();
    }

    private void PopulatePositionInfo() {
        auto vs = VehicleState::ViewingPlayerState();
        VehicleState::GetAllVis(GetApp().GameScene);
        if (vs is null) return;
        Position = vs.Position;
        WorldVel = vs.WorldVel;
        CurGear = vs.CurGear;
        FrontSpeed = vs.FrontSpeed;
        InputSteer = vs.InputSteer;
        InputGasPedal = vs.InputGasPedal;
        InputBrakePedal = vs.InputBrakePedal;
        Left = vs.Left;
        Up = vs.Up;
        Dir = vs.Dir;
        IsGroundContact = vs.IsGroundContact;
        FLSteerAngle = vs.FLSteerAngle;
        FLWheelRot = vs.FLWheelRot;
        FLWheelRotSpeed = vs.FLWheelRotSpeed;
        FLDamperLen = vs.FLDamperLen;
        FLSlipCoef = vs.FLSlipCoef;
        FRSteerAngle = vs.FRSteerAngle;
        FRWheelRot = vs.FRWheelRot;
        FRWheelRotSpeed = vs.FRWheelRotSpeed;
        FRDamperLen = vs.FRDamperLen;
        FRSlipCoef = vs.FRSlipCoef;
        RLSteerAngle = vs.RLSteerAngle;
        RLWheelRot = vs.RLWheelRot;
        RLWheelRotSpeed = vs.RLWheelRotSpeed;
        RLDamperLen = vs.RLDamperLen;
        RLSlipCoef = vs.RLSlipCoef;
        RRSteerAngle = vs.RRSteerAngle;
        RRWheelRot = vs.RRWheelRot;
        RRWheelRotSpeed = vs.RRWheelRotSpeed;
        RRDamperLen = vs.RRDamperLen;
        RRSlipCoef = vs.RRSlipCoef;
#if TMNEXT
        WorldCarUp = vs.WorldCarUp;
        IsWheelsBurning = vs.IsWheelsBurning;
        IsReactorGroundMode = vs.IsReactorGroundMode;
#endif
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
        ret += tostring(InputBrakePedal) + ", ";
        ret += tostring(FLSteerAngle) + ", ";
        ret += tostring(FLWheelRot) + ", ";
        ret += tostring(FLWheelRotSpeed) + ", ";
        ret += tostring(FLDamperLen) + ", ";
        ret += tostring(FLSlipCoef) + ", ";
        ret += tostring(FRSteerAngle) + ", ";
        ret += tostring(FRWheelRot) + ", ";
        ret += tostring(FRWheelRotSpeed) + ", ";
        ret += tostring(FRDamperLen) + ", ";
        ret += tostring(FRSlipCoef) + ", ";
        ret += tostring(RLSteerAngle) + ", ";
        ret += tostring(RLWheelRot) + ", ";
        ret += tostring(RLWheelRotSpeed) + ", ";
        ret += tostring(RLDamperLen) + ", ";
        ret += tostring(RLSlipCoef) + ", ";
        ret += tostring(RRSteerAngle) + ", ";
        ret += tostring(RRWheelRot) + ", ";
        ret += tostring(RRWheelRotSpeed) + ", ";
        ret += tostring(RRDamperLen) + ", ";
        ret += tostring(RRSlipCoef); // + ", ";
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
        ret["FLSteerAngle"] = FLSteerAngle;
        ret["FLWheelRot"] = FLWheelRot;
        ret["FLWheelRotSpeed"] = FLWheelRotSpeed;
        ret["FLDamperLen"] = FLDamperLen;
        ret["FLSlipCoef"] = FLSlipCoef;
        ret["FRSteerAngle"] = FRSteerAngle;
        ret["FRWheelRot"] = FRWheelRot;
        ret["FRWheelRotSpeed"] = FRWheelRotSpeed;
        ret["FRDamperLen"] = FRDamperLen;
        ret["FRSlipCoef"] = FRSlipCoef;
        ret["RLSteerAngle"] = RLSteerAngle;
        ret["RLWheelRot"] = RLWheelRot;
        ret["RLWheelRotSpeed"] = RLWheelRotSpeed;
        ret["RLDamperLen"] = RLDamperLen;
        ret["RLSlipCoef"] = RLSlipCoef;
        ret["RRSteerAngle"] = RRSteerAngle;
        ret["RRWheelRot"] = RRWheelRot;
        ret["RRWheelRotSpeed"] = RRWheelRotSpeed;
        ret["RRDamperLen"] = RRDamperLen;
        ret["RRSlipCoef"] = RRSlipCoef;
        return ret;
    }
}

const string Vec3ToRS(vec3 v) {
    return "vec3(" + string::Join({tostring(v.x), tostring(v.y), tostring(v.z)}, "; ") + ")"; // use something other than ',' so CSV parsing is easier
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
    "InputBrakePedal",
    "FLSteerAngle",
    "FLWheelRot",
    "FLWheelRotSpeed",
    "FLDamperLen",
    "FLSlipCoef",
    "FRSteerAngle",
    "FRWheelRot",
    "FRWheelRotSpeed",
    "FRDamperLen",
    "FRSlipCoef",
    "RLSteerAngle",
    "RLWheelRot",
    "RLWheelRotSpeed",
    "RLDamperLen",
    "RLSlipCoef",
    "RRSteerAngle",
    "RRWheelRot",
    "RRWheelRotSpeed",
    "RRDamperLen",
    "RRSlipCoef"
};

const string DataHeaderRow = string::Join(DataColumnNames, ", ");
