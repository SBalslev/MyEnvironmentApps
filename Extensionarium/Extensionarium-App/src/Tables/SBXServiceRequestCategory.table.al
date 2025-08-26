table 50011 "SBX Service Request Category"
{
    Caption = 'Service Request Category';
    DataClassification = CustomerContent;
    DrillDownPageID = "SBX SR Category List";
    LookupPageID = "SBX SR Category List";

    fields
    {
        field(1; Code; Code[20]) { Caption = 'Code'; }
        field(2; Description; Text[100]) { Caption = 'Description'; }
        field(3; "Default Priority"; Enum "SBX SR Priority") { Caption = 'Default Priority'; }
        field(4; "Default Billable"; Boolean) { Caption = 'Default Billable'; }
        field(5; "Billing Mode Override"; Enum "SBX SR Billing Mode") { Caption = 'Billing Mode Override'; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }
}
