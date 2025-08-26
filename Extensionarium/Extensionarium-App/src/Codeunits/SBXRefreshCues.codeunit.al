codeunit 50322 "SBX Refresh Cues"
{
    Subtype = Normal;
    trigger OnRun()
    var
        CueRec: Record "SBX Property Mgr Cue";
    begin
        if CueRec.Get('CUE') then begin
            CueRec."Last Refreshed" := CurrentDateTime;
            CueRec.Modify(true);
        end;
    end;
}
