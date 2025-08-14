page 50139 "Service Request Timeline"
{
    PageType = ListPart;
    SourceTable = "Service Request Update";
    ApplicationArea = All;
    Caption = 'Updates';
    layout { area(content) { repeater(Updates) { field(ChangeTime; Rec."Change Time") { ApplicationArea = All; } field(OldStatus; Rec."Old Status") { ApplicationArea = All; } field(NewStatus; Rec."New Status") { ApplicationArea = All; } field(Note; Rec.Note) { ApplicationArea = All; } field(ChangedBy; Rec."Changed By") { ApplicationArea = All; } } } }
}
