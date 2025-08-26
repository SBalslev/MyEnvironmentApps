table 50001 "SBX Unit"
{
    Caption = 'Unit';
    DataClassification = CustomerContent;
    DrillDownPageID = "SBX Unit List";
    LookupPageID = "SBX Unit List";

    fields
    {
        field(1; "Property Code"; Code[20]) { Caption = 'Property Code'; TableRelation = "SBX Property"; }
        field(2; "Unit Code"; Code[20]) { Caption = 'Unit Code'; }
        field(3; "Unit Type"; Enum "SBX Unit Type") { Caption = 'Unit Type'; }
        field(4; Floor; Code[10]) { Caption = 'Floor'; }
        field(5; "Area"; Decimal) { Caption = 'Area'; DecimalPlaces = 0 : 5; }
        field(6; Status; Enum "SBX Unit Status") { Caption = 'Status'; }
        field(7; "Out of Service Reason"; Text[100]) { Caption = 'Out of Service Reason'; }
        field(8; "Dimension Set ID"; Integer) { Editable = false; Caption = 'Dimension Set ID'; }
        field(9; "Last Modified"; DateTime) { Editable = false; Caption = 'Last Modified'; }
    }

    keys
    {
        key(PK; "Property Code", "Unit Code") { Clustered = true; }
        key(UnitOnly; "Unit Code") { }
    }

    trigger OnModify()
    begin
        Rec."Last Modified" := CurrentDateTime;
    end;

    trigger OnInsert()
    var
        NoSeriesHlp: Codeunit "SBX No. Series Helper";
    begin
        Rec."Last Modified" := CurrentDateTime;
        if Rec."Unit Code" = '' then
            Rec."Unit Code" := NoSeriesHlp.GetNextUnitNo();
    end;
}
