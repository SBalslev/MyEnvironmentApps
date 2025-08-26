// Renamed from SBXDepositLedgerListPart.page.al to satisfy AA0215
page 50109 "SBX Deposit Ledger Entries"
{
    Caption = 'Deposit Ledger';
    PageType = ListPart;
    SourceTable = "SBX Deposit Ledger Entry";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; ToolTip = 'Date the deposit transaction posted.'; }
                field(Amount; Rec.Amount) { ApplicationArea = All; ToolTip = 'Amount of the deposit transaction.'; }
                field(Type; Rec.Type) { ApplicationArea = All; ToolTip = 'Transaction type (e.g. Collected, Applied).'; }
                field("Document No."; Rec."Document No.") { ApplicationArea = All; ToolTip = 'Reference document number.'; }
            }
        }
    }
}
