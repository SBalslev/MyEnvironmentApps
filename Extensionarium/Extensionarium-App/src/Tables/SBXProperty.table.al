table 50000 "SBX Property"
{
    Caption = 'Property';
    DataClassification = CustomerContent;
    DrillDownPageID = "SBX Property List";
    LookupPageID = "SBX Property List";

    fields
    {
        field(1; "Code"; Code[20]) { Caption = 'Code'; DataClassification = CustomerContent; }
        field(2; "Name"; Text[100]) { Caption = 'Name'; }
        field(3; "Address 1"; Text[100]) { Caption = 'Address 1'; }
        field(4; "Address 2"; Text[50]) { Caption = 'Address 2'; }
        field(5; City; Text[30]) { Caption = 'City'; }
        field(6; "Post Code"; Code[20]) { Caption = 'Post Code'; }
        field(7; "Country/Region Code"; Code[10]) { Caption = 'Country/Region Code'; TableRelation = "Country/Region"; }
        field(8; Status; Enum "SBX Property Status") { Caption = 'Status'; }
        field(9; "Portfolio/Region Code"; Code[20]) { Caption = 'Portfolio/Region Code'; DataClassification = CustomerContent; }
        field(10; "Default Unit Area UoM"; Code[10]) { Caption = 'Default Unit Area UoM'; }
        field(11; "Dimension Set ID"; Integer) { Caption = 'Dimension Set ID'; Editable = false; }
        field(12; "Last Modified"; DateTime) { Editable = false; Caption = 'Last Modified'; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }

    trigger OnModify()
    begin
        Rec."Last Modified" := CurrentDateTime;
    end;

    trigger OnInsert()
    var
        NoSeriesHlp: Codeunit "SBX No. Series Helper";
    begin
        if Rec.Code = '' then
            Rec.Code := NoSeriesHlp.GetNextPropertyNo();
        Rec."Last Modified" := CurrentDateTime;
    end;
}
