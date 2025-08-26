page 50108 "SBX Recurring Charge Lines"
{
    Caption = 'Recurring Charge Lines';
    PageType = ListPart;
    SourceTable = "SBX Recurring Charge Line";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Charge Code"; Rec."Charge Code") { ApplicationArea = All; }
                field("Charge Type"; Rec."Charge Type") { ApplicationArea = All; }
                field(Amount; Rec.Amount) { ApplicationArea = All; }
                field("Next Run Date"; Rec."Next Run Date") { ApplicationArea = All; }
                field(Blocked; Rec.Blocked) { ApplicationArea = All; }
            }
        }
    }
}
