bool g_isRecording = false;

void Main() {}

void Update(float dt) {
    if (Setting_Enabled && g_isRecording && IsInGame())
        RecordPosition();
}

bool IsInGame() {
    auto app = cast<CTrackMania>(GetApp());
    if (app.RootMap is null) return false;
    try {
        return true;
        // auto gt = cast<CGameTerminal>(app.CurrentPlayground.GameTerminals[0]);
        // return gt.UISequence_Current == SGamePlaygroundUIConfig::EUISequence::Playing;
    } catch {
        // trace('exception: ' + getExceptionInfo());
    }
    return false;
}

bool keyDown_ctrl = false;
bool keyDown_alt = false;
bool keyDown_shift = false;

UI::InputBlocking OnKeyPress(bool down, VirtualKey key) {
    if (!Setting_ShortcutKeyEnabled) return UI::InputBlocking::DoNothing;
    switch (key) {
        case VirtualKey::Control: keyDown_ctrl = down; break;
        case VirtualKey::Menu: keyDown_alt = down; break;
        case VirtualKey::Shift: keyDown_shift = down; break;
    }
    if (key == Setting_ShortcutKeyChoice && down)
        OnShortcutKeyPress();
    return UI::InputBlocking::DoNothing;
}

// if modifier conditions are met, enable the plugin, or toggle recording
void OnShortcutKeyPress() {
    if (g_currentlySavingRecording || (!g_isRecording && !IsInGame())) return; // don't do anything if we're actively saving or not recording and not in game
    // modifiers
    bool modifiersOkay = true
        && (!Setting_ModifierCtrl || keyDown_ctrl)
        && (!Setting_ModifierAlt || keyDown_alt)
        && (!Setting_ModifierShift || keyDown_shift);
    if (!modifiersOkay) return;
    // if the plugin isn't enabled, then enable it
    if (!Setting_Enabled) {
        Setting_Enabled = true;
        return; // but don't start recording
    }
    // main action
    startnew(OnRecordingToggle);
}

const string ShortcutKeyText() {
    string ret = "";
    if (Setting_ModifierCtrl) ret += "Ctrl + ";
    if (Setting_ModifierAlt) ret += "Alt + ";
    if (Setting_ModifierShift) ret += "Shift + ";
    ret += tostring(Setting_ShortcutKeyChoice);
    return ret;
}

// in scripts
void RenderMenu() {
    if (UI::MenuItem("\\$f11" + Icons::VideoCamera + "\\$z Record Raw Vehicle Data", ShortcutKeyText(), Setting_Enabled)) {
        Setting_Enabled = !Setting_Enabled;
        if (!Setting_Enabled && g_isRecording) {  // check if we need to stop recording
            startnew(OnRecordingToggle);
        }
    }
}

string statusMsg = "";
void RenderMenuMain() {
    if (!Setting_Enabled) return;
    string shortcutKey = "";
    if (Setting_ShortcutKeyEnabled) {
        shortcutKey = " \\$bbb(" + ShortcutKeyText() + ")";
    }
    statusMsg = GenStatusString() + shortcutKey;
    if (UI::BeginMenu("\\$f11" + Icons::Circle + "\\$z RRVD: " + statusMsg + "##recVechildRawMenuMain", !g_currentlySavingRecording && (g_isRecording || IsInGame()))) {
        // when the menu opens, we want to change the state. That will change the label -> close the menu.
        // this ~mimics clicking a button
        UI::EndMenu();
    }
    if (UI::IsItemClicked())
        startnew(OnRecordingToggle);
    if (!g_currentlySavingRecording && UI::IsItemHovered()) {
        UI::BeginTooltip();
        UI::Text("Click to " + (g_isRecording ? "stop" : "start") + " recording; or press " + ShortcutKeyText());
        UI::EndTooltip();
    }
}

const string GenStatusString() {
    if (g_currentlySavingRecording)
        return "Saving (" + g_savedSoFar + " / " + FramesRecorded() + ")";
    if (!g_isRecording)
        return "Not Recording";
    return "Recording (" + FramesRecorded() + " frames)";
}

uint FramesRecorded() {
    return positions.Length;
}

void NotifyStatus(const string &in msg, uint time = 5000) {
    UI::ShowNotification("Record Raw Vehicle Data", msg, vec4(.2, .6, 0, .3), time);
}

void NotifyWarn(const string &in msg) {
    UI::ShowNotification("Record Raw Vehicle Data", msg, vec4(.8, .2, .1, .3), 10000);
}
