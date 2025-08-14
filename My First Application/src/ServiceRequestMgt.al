codeunit 50100 "Service Request Mgt"
{
    SingleInstance = false;

    procedure InitNewServiceRequest(var RecSR: Record "Service Request")
    begin
        if RecSR."Opened At" = 0DT then
            RecSR."Opened At" := CurrentDateTime;
        // Ensure default initial status
        if RecSR.Status <> RecSR.Status::New then
            RecSR.Status := RecSR.Status::New;
        CalcSLADue(RecSR);
    end;

    procedure CalcSLADue(var RecSR: Record "Service Request")
    var
        HoursToAdd: Integer;
    begin
        case RecSR.Priority of
            RecSR.Priority::Emergency:
                HoursToAdd := 4;
            RecSR.Priority::High:
                HoursToAdd := 24;
            RecSR.Priority::Medium:
                HoursToAdd := 72;
            RecSR.Priority::Low:
                HoursToAdd := 120;
        end;
        RecSR."SLA Due At" := CreateDateTime(Today, 000000T) + (HoursToAdd * 3600000);
    end;

    procedure UpdateStatus(var RecSR: Record "Service Request"; NewStatus: Enum "Service Status"; Note: Text[250])
    var
        Update: Record "Service Request Update";
        OldStatus: Enum "Service Status";
    begin
        OldStatus := RecSR.Status;
        ValidateTransition(OldStatus, NewStatus);
        RecSR.Status := NewStatus;
        if (NewStatus = RecSR.Status::Completed) or (NewStatus = RecSR.Status::Cancelled) then begin
            if RecSR."Closed At" = 0DT then
                RecSR."Closed At" := CurrentDateTime;
        end;
        RecSR.Modify(true);

        Update.Init;
        Update."Service Request No." := RecSR."No.";
        Update."Old Status" := OldStatus;
        Update."New Status" := NewStatus;
        Update.Note := CopyStr(Note, 1, MaxStrLen(Update.Note));
        Update."Changed By" := UserId;
        Update."Change Time" := CurrentDateTime;
        Update.Insert(true);
    end;

    local procedure ValidateTransition(FromStatus: Enum "Service Status"; ToStatus: Enum "Service Status")
    begin
        case FromStatus of
            FromStatus::New:
                if not (ToStatus in [ToStatus::Triaged, ToStatus::Cancelled]) then
                    Error('Invalid transition from %1 to %2', FromStatus, ToStatus);
            FromStatus::Triaged:
                if not (ToStatus in [ToStatus::Assigned, ToStatus::"On Hold", ToStatus::Cancelled]) then
                    Error('Invalid transition from %1 to %2', FromStatus, ToStatus);
            FromStatus::Assigned:
                if not (ToStatus in [ToStatus::"In Progress", ToStatus::"On Hold", ToStatus::Cancelled]) then
                    Error('Invalid transition from %1 to %2', FromStatus, ToStatus);
            FromStatus::"In Progress":
                if not (ToStatus in [ToStatus::Completed, ToStatus::"On Hold", ToStatus::Cancelled]) then
                    Error('Invalid transition from %1 to %2', FromStatus, ToStatus);
            FromStatus::"On Hold":
                if not (ToStatus in [ToStatus::Triaged, ToStatus::Assigned, ToStatus::"In Progress", ToStatus::Cancelled]) then
                    Error('Invalid transition from %1 to %2', FromStatus, ToStatus);
            FromStatus::Completed, FromStatus::Cancelled:
                if FromStatus <> ToStatus then
                    Error('Cannot transition from a closed status (%1).', FromStatus);
        end;
    end;
}
