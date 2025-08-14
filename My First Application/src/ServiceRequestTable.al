table 50104 "Service Request"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20]) { DataClassification = CustomerContent; }
        field(2; "Property ID"; Code[20]) { DataClassification = CustomerContent; TableRelation = Property."ID"; }
        field(3; "Unit No."; Code[20]) { DataClassification = CustomerContent; TableRelation = Unit."No."; }
        field(4; "Lease No."; Code[20]) { DataClassification = CustomerContent; TableRelation = Lease."No."; }
        field(5; "Tenant No."; Code[20]) { DataClassification = CustomerContent; TableRelation = Tenant."No."; }
        field(6; Category; Enum "Service Category") { DataClassification = CustomerContent; }
        field(7; Priority; Enum "Service Priority") { DataClassification = CustomerContent; }
        field(8; Title; Text[100]) { DataClassification = CustomerContent; }
        field(9; Description; Text[250]) { DataClassification = CustomerContent; }
        field(10; Status; Enum "Service Status") { DataClassification = CustomerContent; }
        field(11; "Opened At"; DateTime) { DataClassification = CustomerContent; }
        field(12; "Closed At"; DateTime) { DataClassification = CustomerContent; }
        field(13; "SLA Due At"; DateTime) { DataClassification = CustomerContent; }
        field(14; "Estimated Cost"; Decimal) { DataClassification = CustomerContent; DecimalPlaces = 0 : 2; }
        field(15; "Actual Cost"; Decimal) { DataClassification = CustomerContent; DecimalPlaces = 0 : 2; }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
        key(StatusIdx; Status) { }
        key(PropertyIdx; "Property ID") { }
    }

    trigger OnInsert()
    var
        NoMgt: Codeunit "Rental No. Series Mgt";
    begin
        if "No." = '' then
            NoMgt.AssignServiceRequestNo(Rec);
        if "Opened At" = 0DT then
            "Opened At" := CurrentDateTime;
    end;
}
