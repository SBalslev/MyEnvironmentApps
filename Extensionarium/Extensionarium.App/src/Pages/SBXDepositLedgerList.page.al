page 50112 "SBX Deposit Ledger"
{
    Caption = 'Deposit Ledger';
    PageType = List;
    SourceTable = "SBX Deposit Ledger Entry";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageID = "SBX Deposit Ledger Card";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; }
                field("Lease No."; Rec."Lease No.") { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field(Type; Rec.Type) { ApplicationArea = All; }
                field(Amount; Rec.Amount) { ApplicationArea = All; }
                field("Document No."; Rec."Document No.") { ApplicationArea = All; }
            }
        }
    }
}
