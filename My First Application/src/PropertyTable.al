table 50100 Property
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "ID"; Code[20]) { DataClassification = CustomerContent; Caption = 'Code'; }
        field(2; Name; Text[100]) { DataClassification = CustomerContent; }
        field(3; Type; Enum "Property Type") { DataClassification = CustomerContent; }
        field(4; Address; Text[250]) { DataClassification = CustomerContent; }
        field(5; City; Text[50]) { DataClassification = CustomerContent; }
        field(6; "State/Region"; Text[50]) { DataClassification = CustomerContent; }
        field(7; "Postal Code"; Code[20]) { DataClassification = CustomerContent; }
        field(8; Country; Code[10]) { DataClassification = CustomerContent; }
        field(9; Status; Enum "Property Status") { DataClassification = CustomerContent; }
        field(10; "Acquisition Date"; Date) { DataClassification = CustomerContent; }
        field(11; Notes; Text[250]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "ID") { Clustered = true; }
        key(NameIdx; Name) { }
        key(CityIdx; City) { }
    }

    trigger OnInsert()
    var
        NoMgt: Codeunit "Rental No. Series Mgt";
    begin
        if "ID" = '' then
            NoMgt.AssignPropertyNo(Rec);
    end;
}
