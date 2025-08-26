table 50009 "SBX Lease Amendment History"
{
    Caption = 'Lease Amendment History';
    DataClassification = CustomerContent;
    DrillDownPageID = "SBX Lease Amendment History";
    LookupPageID = "SBX Lease Amendment History";

    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; Caption = 'Entry No.'; }
        field(2; "Lease No."; Code[20]) { Caption = 'Lease No.'; TableRelation = "SBX Lease"; }
        field(3; "Version No."; Integer) { Caption = 'Version No.'; }
        field(4; "Effective Start Date"; Date) { Caption = 'Effective Start Date'; }
        field(5; "Effective End Date"; Date) { Caption = 'Effective End Date'; }
        field(6; "Base Rent Amount"; Decimal) { Caption = 'Base Rent Amount'; }
        field(7; "Billing Interval"; Integer) { Caption = 'Billing Interval'; }
        field(8; "Billing Frequency Type"; Enum "SBX Charge Frequency Type") { Caption = 'Billing Frequency Type'; }
        field(9; "Deposit Amount"; Decimal) { Caption = 'Deposit Amount'; }
        field(10; "Change Diff JSON"; Blob)
        {
            Caption = 'Change Diff JSON';
            SubType = Memo;
        }
        field(11; "User ID"; Code[50]) { Caption = 'User ID'; }
        field(12; "Created DateTime"; DateTime) { Caption = 'Created DateTime'; }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(LeaseVer; "Lease No.", "Version No.") { }
    }
}
