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
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field(Amount; Rec.Amount) { ApplicationArea = All; }
                field(Type; Rec.Type) { ApplicationArea = All; }
                field("Document No."; Rec."Document No.") { ApplicationArea = All; }
            }
        }
    }
}
