uint g_savedSoFar = 0;
bool g_currentlySavingRecording = false;
uint lastStart = 0;  // for yielding while saving

[Setting category="Performance" name="Frametime Overhead Limit Whilst Saving (ms)" min="0" max="9" description="Take 1+value miliseconds per-frame on average when saving vehicle data. Increase to save faster but increase frame times. At low values there will be no impact (CPU dependent)."]
uint saveIncrementsAllowMs = 2;  // max execution ms without yielding

void SaveData() {
    NotifyStatus("Saving data from " + FramesRecorded() + " frames.");
    lastStart = Time::Now;
    g_currentlySavingRecording = true;
    g_savedSoFar = 0;
    // files & prep
    string filenameNoSfx = IO::FromStorageFolder(YYYYMMDD() + " " + HHMMSS() + " " + FramesRecorded() + "-frames " + LastRecordedMap);
    IO::File csvFile(filenameNoSfx + ".csv", IO::FileMode::Write);
    IO::File jsonFile(filenameNoSfx + ".json", IO::FileMode::Write);
    csvFile.WriteLine(DataHeaderRow);
    // dump positions
    for (uint i = 0; i < positions.Length; i++) {
        if (YeildDuringSave()) {
            yield();
            lastStart = Time::Now;
        }
        VehiclePosition@ item = positions[i];
        csvFile.WriteLine(item.ToRowString());
        jsonFile.WriteLine((i == 0 ? "[ " : ", ") + Json::Write(item.ToJson()));
        g_savedSoFar++;
    }
    jsonFile.WriteLine("]");
    g_currentlySavingRecording = false;
    NotifyStatus("Saved as " + filenameNoSfx + ".{csv,json}", 7500);
}

bool YeildDuringSave() {
    return Time::Now > lastStart + saveIncrementsAllowMs;
}

const string GetMapName() {
    auto map = GetApp().RootMap;
    if (map !is null) {
        return StripFormatCodes(map.MapName);
    }
    return "";
}

const string YYYYMMDD() {
    auto info = Time::Parse(Time::Stamp);
    return string::Join({tostring(info.Year), TwoDig(info.Month), TwoDig(info.Day)}, "-");
}

const string HHMMSS() {
    auto info = Time::Parse(Time::Stamp);
    return TwoDig(info.Hour) + "-" + TwoDig(info.Minute) + "-" + TwoDig(info.Second);
}

const string TwoDig(uint v) {
    return Text::Format("%02d", v);
}
