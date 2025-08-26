table 50003 "SBX Lease Charge Template"
{
    Caption = 'Lease Charge Template';
    DataClassification = CustomerContent;
    DrillDownPageID = "SBX Lease Charge Template List";
    LookupPageID = "SBX Lease Charge Template List";

    fields
    {
        field(1; Code; Code[20]) { Caption = 'Code'; }
        field(2; Description; Text[100]) { Caption = 'Description'; }
        field(3; "Charge Type"; Enum "SBX Charge Type") { Caption = 'Charge Type'; }
        field(4; "Frequency Interval"; Integer) { Caption = 'Frequency Interval'; }
        field(5; "Frequency Type"; Enum "SBX Charge Frequency Type") { Caption = 'Frequency Type'; }
        field(6; Amount; Decimal) { Caption = 'Amount'; DecimalPlaces = 2 : 5; }
        field(7; Formula; Text[100]) { Caption = 'Formula'; ToolTip = 'Optional formula for future dynamic calculation. Leave blank for fixed Amount.'; }
        field(8; "Requires Meter"; Boolean) { Caption = 'Requires Meter'; }
        field(9; Active; Boolean) { Caption = 'Active'; }
        field(10; "Dimension Behavior"; Enum "SBX Dimension Behavior") { Caption = 'Dimension Behavior'; }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }
}
