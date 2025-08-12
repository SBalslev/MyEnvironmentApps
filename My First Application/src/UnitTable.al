table 50101 Unit
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20]) { DataClassification = CustomerContent; }
        field(2; "Property ID"; Code[20]) { DataClassification = CustomerContent; TableRelation = Property."ID"; }
        field(3; "Unit Label"; Text[50]) { DataClassification = CustomerContent; }
        field(4; Bedrooms; Integer) { DataClassification = CustomerContent; }
        field(5; Bathrooms; Decimal) { DataClassification = CustomerContent; DecimalPlaces = 0 : 1; }
        field(6; "Square Feet"; Integer) { DataClassification = CustomerContent; }
        field(7; Floor; Integer) { DataClassification = CustomerContent; }
        field(8; "Market Rent"; Decimal) { DataClassification = CustomerContent; DecimalPlaces = 0 : 2; }
        field(9; Status; Enum "Unit Status") { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
        key(PropertyIdx; "Property ID") { }
    }

    trigger OnInsert()
    var
        NoMgt: Codeunit "Rental No. Series Mgt";
    begin
        if "No." = '' then
            NoMgt.AssignUnitNo(Rec);
    end;
}
