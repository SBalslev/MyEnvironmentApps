table 50004 "SBX Recurring Charge Line"
{
    Caption = 'Recurring Charge Line';
    DataClassification = CustomerContent;
    DrillDownPageID = "SBX Recurring Charge Line List";
    LookupPageID = "SBX Recurring Charge Line List";

    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; Caption = 'Entry No.'; }
        field(2; "Lease No."; Code[20]) { Caption = 'Lease No.'; TableRelation = "SBX Lease"; }
        field(3; "Charge Code"; Code[20]) { Caption = 'Charge Code'; TableRelation = "SBX Lease Charge Template"; }
        field(4; "Charge Type"; Enum "SBX Charge Type") { Caption = 'Charge Type'; }
        field(5; Amount; Decimal) { Caption = 'Amount'; DecimalPlaces = 2 : 5; }
        field(6; "Frequency Interval"; Integer) { Caption = 'Frequency Interval'; }
        field(7; "Frequency Type"; Enum "SBX Charge Frequency Type") { Caption = 'Frequency Type'; }
        field(8; "Next Run Date"; Date) { Caption = 'Next Run Date'; }
        field(9; "Last Posted Date"; Date) { Caption = 'Last Posted Date'; Editable = false; }
        field(10; "Prorate First"; Boolean) { Caption = 'Prorate First'; }
        field(11; "Prorate Last"; Boolean) { Caption = 'Prorate Last'; }
        field(12; "Dimension Set ID"; Integer) { Editable = false; }
        field(13; Blocked; Boolean) { Caption = 'Blocked'; }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(NextRun; "Next Run Date", Blocked, "Lease No.") { }
    }
}
