// Renamed from SBXRecurringChargeLineListPart.page.al to satisfy AA0215
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
                field("Charge Code"; Rec."Charge Code") { ApplicationArea = All; ToolTip = 'Code of the associated charge template.'; }
                field("Charge Type"; Rec."Charge Type") { ApplicationArea = All; ToolTip = 'Functional type of the recurring charge.'; }
                field(Amount; Rec.Amount) { ApplicationArea = All; ToolTip = 'Recurring amount billed each period.'; }
                field("Next Run Date"; Rec."Next Run Date") { ApplicationArea = All; ToolTip = 'Date the next charge posting is scheduled.'; }
                field(Blocked; Rec.Blocked) { ApplicationArea = All; ToolTip = 'Specifies whether this line is blocked from generating charges.'; }
            }
        }
    }
}
