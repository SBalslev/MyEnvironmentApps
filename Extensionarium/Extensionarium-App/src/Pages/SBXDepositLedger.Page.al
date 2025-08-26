// Renamed from SBXDepositLedgerList.page.al to satisfy AA0215
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
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; ToolTip = 'Sequential entry number.'; }
                field("Lease No."; Rec."Lease No.") { ApplicationArea = All; ToolTip = 'Lease related to the deposit movement.'; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; ToolTip = 'Date the deposit transaction posted.'; }
                field(Type; Rec.Type) { ApplicationArea = All; ToolTip = 'Transaction type (e.g. Collected, Applied).'; }
                field(Amount; Rec.Amount) { ApplicationArea = All; ToolTip = 'Amount of the deposit transaction.'; }
                field("Document No."; Rec."Document No.") { ApplicationArea = All; ToolTip = 'Reference document number.'; }
            }
        }
    }
}
