table 50102 Tenant
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20]) { DataClassification = CustomerContent; }
        field(2; "First Name"; Text[50]) { DataClassification = CustomerContent; }
        field(3; "Last Name"; Text[50]) { DataClassification = CustomerContent; }
        field(4; Email; Text[80]) { DataClassification = CustomerContent; }
        field(5; Phone; Text[30]) { DataClassification = CustomerContent; }
        field(6; Status; Enum "Tenant Status") { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
        key(EmailIdx; Email) { }
        key(NameIdx; "Last Name", "First Name") { }
    }

    trigger OnInsert()
    var
        NoMgt: Codeunit "Rental No. Series Mgt";
    begin
        if "No." = '' then
            NoMgt.AssignTenantNo(Rec);
    end;
}
