table 50006 "SBX Deposit Ledger Entry"
{
    Caption = 'Deposit Ledger Entry';
    DataClassification = CustomerContent;
    DrillDownPageID = "SBX Deposit Ledger";
    LookupPageID = "SBX Deposit Ledger";

    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; Caption = 'Entry No.'; }
        field(2; "Lease No."; Code[20]) { Caption = 'Lease No.'; TableRelation = "SBX Lease"; }
        field(3; "Posting Date"; Date) { Caption = 'Posting Date'; }
        field(4; Amount; Decimal) { Caption = 'Amount'; DecimalPlaces = 2 : 5; }
        field(5; Type; Enum "SBX Deposit Entry Type") { Caption = 'Type'; }
        field(6; "Document No."; Code[20]) { Caption = 'Document No.'; }
        field(7; "Sales Invoice No."; Code[20]) { Caption = 'Sales Invoice No.'; TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Invoice)); }
        field(8; "User ID"; Code[50]) { Caption = 'User ID'; }
        field(9; "Created DateTime"; DateTime) { Caption = 'Created DateTime'; }
        field(10; "Collected Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("SBX Deposit Ledger Entry".Amount WHERE("Lease No." = FIELD("Lease No."), Type = FILTER(Collected)));
            Editable = false;
            Caption = 'Collected Amount';
        }
        field(11; "Applied/Released Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("SBX Deposit Ledger Entry".Amount WHERE("Lease No." = FIELD("Lease No."), Type = FILTER(Applied | Refunded | Forfeited)));
            Editable = false;
            Caption = 'Applied/Released Amount';
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(LeaseIdx; "Lease No.") { }
    }
}
