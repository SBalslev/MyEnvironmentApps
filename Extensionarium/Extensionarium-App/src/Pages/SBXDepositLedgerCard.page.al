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
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; Editable = false; ToolTip = 'Sequential internal identifier of the deposit ledger entry.'; }
                field("Lease No."; Rec."Lease No.") { ApplicationArea = All; ToolTip = 'Related lease number.'; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; ToolTip = 'Date the deposit entry was posted.'; }
                field(Type; Rec.Type) { ApplicationArea = All; ToolTip = 'Type of deposit ledger transaction (e.g. Collected, Applied).'; }
                field(Amount; Rec.Amount) { ApplicationArea = All; ToolTip = 'Amount of the deposit transaction.'; }
                field("Document No."; Rec."Document No.") { ApplicationArea = All; ToolTip = 'Reference document number.'; }
                field("Sales Invoice No."; Rec."Sales Invoice No.") { ApplicationArea = All; ToolTip = 'Sales invoice number linked to this deposit (if any).'; }
                field("User ID"; Rec."User ID") { ApplicationArea = All; ToolTip = 'User who created the entry.'; }
                field("Created DateTime"; Rec."Created DateTime") { ApplicationArea = All; Editable = false; ToolTip = 'Timestamp when the entry was created.'; }
            }
        }
    }
}