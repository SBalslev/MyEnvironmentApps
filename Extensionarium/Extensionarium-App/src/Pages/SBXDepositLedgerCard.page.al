page 50118 "SBX Deposit Ledger Card"
{
    Caption = 'Deposit Ledger Entry';
    PageType = Card;
    SourceTable = "SBX Deposit Ledger Entry";
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; Editable = false; }
                field("Lease No."; Rec."Lease No.") { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field(Type; Rec.Type) { ApplicationArea = All; }
                field(Amount; Rec.Amount) { ApplicationArea = All; }
                field("Document No."; Rec."Document No.") { ApplicationArea = All; }
                field("Sales Invoice No."; Rec."Sales Invoice No.") { ApplicationArea = All; }
                field("User ID"; Rec."User ID") { ApplicationArea = All; }
                field("Created DateTime"; Rec."Created DateTime") { ApplicationArea = All; Editable = false; }
            }
        }
    }
}