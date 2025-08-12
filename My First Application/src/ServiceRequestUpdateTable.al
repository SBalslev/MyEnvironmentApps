table 50105 "Service Request Update"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { DataClassification = CustomerContent; AutoIncrement = true; }
        field(2; "Service Request No."; Code[20]) { DataClassification = CustomerContent; TableRelation = "Service Request"."No."; }
        field(3; "Old Status"; Enum "Service Status") { DataClassification = CustomerContent; }
        field(4; "New Status"; Enum "Service Status") { DataClassification = CustomerContent; }
        field(5; Note; Text[250]) { DataClassification = CustomerContent; }
        field(6; "Changed By"; Code[50]) { DataClassification = CustomerContent; }
        field(7; "Change Time"; DateTime) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(ServiceIdx; "Service Request No.") { }
    }
}
