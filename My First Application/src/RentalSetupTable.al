table 50106 "Rental Setup"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10]) { DataClassification = CustomerContent; }
    field(2; "Property Nos."; Code[20]) { DataClassification = CustomerContent; }
    field(3; "Unit Nos."; Code[20]) { DataClassification = CustomerContent; }
    field(4; "Tenant Nos."; Code[20]) { DataClassification = CustomerContent; }
    field(5; "Lease Nos."; Code[20]) { DataClassification = CustomerContent; }
    field(6; "Service Request Nos."; Code[20]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }

    trigger OnInsert()
    begin
        if "Primary Key" = '' then
            "Primary Key" := 'SETUP';
    end;
}
