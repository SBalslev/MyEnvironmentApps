table 50008 "SBX Extensionarium Setup"
{
    Caption = 'Extensionarium Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10]) { Caption = 'Primary Key'; }
        field(2; "Property No. Series"; Code[20]) { Caption = 'Property No. Series'; TableRelation = "No. Series"; }
        field(3; "Unit No. Series"; Code[20]) { Caption = 'Unit No. Series'; TableRelation = "No. Series"; }
        field(4; "Lease No. Series"; Code[20]) { Caption = 'Lease No. Series'; TableRelation = "No. Series"; }
        field(5; "Service Req. No. Series"; Code[20]) { Caption = 'Service Request No. Series'; TableRelation = "No. Series"; }
        field(6; "Enable Meter"; Boolean) { Caption = 'Enable Meter'; }
        field(7; "Enable Consolidated Invoicing"; Boolean) { Caption = 'Enable Consolidated Invoicing'; }
        field(8; "Unit Shortcut Dimension Code"; Code[20]) { Caption = 'Unit Shortcut Dimension Code'; }
        field(9; "Automatic Charge Generation"; Boolean) { Caption = 'Automatic Charge Generation'; }
        field(10; "Default Charge Desc Pattern"; Text[100]) { Caption = 'Default Charge Posting Description Pattern'; }
        field(11; "Default Proration Method"; Enum "SBX Proration Method") { Caption = 'Default Proration Method'; }
        field(12; "SR Billing Mode"; Enum "SBX SR Billing Mode") { Caption = 'Service Request Billing Mode'; }
        field(13; "Rent G/L Account"; Code[20]) { Caption = 'Rent G/L Account'; TableRelation = "G/L Account"; }
        field(14; "Charge G/L Account"; Code[20]) { Caption = 'Other Charge G/L Account'; TableRelation = "G/L Account"; }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}
