table 50002 "SBX Lease"
{
    Caption = 'Lease';
    DataClassification = CustomerContent;
    DrillDownPageID = "SBX Lease List";
    LookupPageID = "SBX Lease List";

    fields
    {
        field(1; "No."; Code[20]) { Caption = 'No.'; }
        field(2; "Customer No."; Code[20]) { Caption = 'Customer No.'; TableRelation = Customer; }
        field(3; "Property Code"; Code[20]) { Caption = 'Property Code'; TableRelation = "SBX Property"; }
        field(4; "Unit Code"; Code[20]) { Caption = 'Unit Code'; TableRelation = "SBX Unit"."Unit Code" WHERE("Property Code" = FIELD("Property Code")); }
        field(5; "Start Date"; Date) { Caption = 'Start Date'; }
        field(6; "End Date"; Date) { Caption = 'End Date'; }
        field(7; "Move-In Date"; Date) { Caption = 'Move-In Date'; }
        field(8; "Move-Out Date"; Date) { Caption = 'Move-Out Date'; }
        field(9; "Signed Date"; Date) { Caption = 'Signed Date'; }
        field(10; "Signed Document"; Media) { Caption = 'Signed Document'; DataClassification = CustomerContent; }
        field(11; "Billing Start Date"; Date) { Caption = 'Billing Start Date'; }
        field(12; Status; Enum "SBX Lease Status") { Caption = 'Status'; }
        field(13; "Billing Frequency Interval"; Integer) { Caption = 'Billing Frequency Interval'; }
        field(14; "Frequency Type"; Enum "SBX Charge Frequency Type") { Caption = 'Frequency Type'; }
        field(15; "Base Rent Amount"; Decimal) { Caption = 'Base Rent Amount'; DecimalPlaces = 2 : 5; }
        field(16; "Deposit Amount"; Decimal) { Caption = 'Deposit Amount'; DecimalPlaces = 2 : 5; }
        field(17; "Currency Code"; Code[10]) { Caption = 'Currency Code'; TableRelation = Currency; }
        field(18; "Termination Notice Days"; Integer) { Caption = 'Termination Notice Days'; }
        field(19; "Current Version No."; Integer) { Caption = 'Current Version No.'; Editable = false; }
        field(20; "Next Amendment Effective Date"; Date) { Caption = 'Next Amendment Effective Date'; }
        field(21; "Last Invoiced Through Date"; Date) { Caption = 'Last Invoiced Through Date'; Editable = false; }
        field(22; "Dimension Set ID"; Integer) { Editable = false; }
        field(23; "Created DateTime"; DateTime) { Editable = false; }
        field(24; "Last Modified DateTime"; DateTime) { Editable = false; }
        field(25; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
        key(UnitLease; "Unit Code") { }
    }

    trigger OnInsert()
    var
        NoSeriesHlp: Codeunit "SBX No. Series Helper";
    begin
        if Rec."No." = '' then
            Rec."No." := NoSeriesHlp.GetNextLeaseNo();
        Rec."Created DateTime" := CurrentDateTime;
        Rec."Last Modified DateTime" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        Rec."Last Modified DateTime" := CurrentDateTime;
    end;
}
