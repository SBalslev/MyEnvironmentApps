page 50119 "SBX Recurring Charge Line List"
{
    Caption = 'Recurring Charge Lines';
    PageType = List;
    SourceTable = "SBX Recurring Charge Line";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; }
                field("Lease No."; Rec."Lease No.") { ApplicationArea = All; }
                field("Charge Code"; Rec."Charge Code") { ApplicationArea = All; }
                field("Charge Type"; Rec."Charge Type") { ApplicationArea = All; }
                field(Amount; Rec.Amount) { ApplicationArea = All; }
                field("Next Run Date"; Rec."Next Run Date") { ApplicationArea = All; }
                field("Last Posted Date"; Rec."Last Posted Date") { ApplicationArea = All; }
                field(Blocked; Rec.Blocked) { ApplicationArea = All; }
            }
        }
    }
}