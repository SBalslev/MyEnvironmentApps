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
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; ToolTip = 'Internal identifier of the recurring charge line.'; }
                field("Lease No."; Rec."Lease No.") { ApplicationArea = All; ToolTip = 'Lease to which this recurring charge applies.'; }
                field("Charge Code"; Rec."Charge Code") { ApplicationArea = All; ToolTip = 'Code of the associated charge template.'; }
                field("Charge Type"; Rec."Charge Type") { ApplicationArea = All; ToolTip = 'Functional charge classification (e.g. Base Rent).'; }
                field(Amount; Rec.Amount) { ApplicationArea = All; ToolTip = 'Recurring amount billed each period.'; }
                field("Next Run Date"; Rec."Next Run Date") { ApplicationArea = All; ToolTip = 'Date the next charge posting is scheduled.'; }
                field("Last Posted Date"; Rec."Last Posted Date") { ApplicationArea = All; ToolTip = 'Date the charge was last posted.'; }
                field(Blocked; Rec.Blocked) { ApplicationArea = All; ToolTip = 'Specifies whether this line is blocked from generating charges.'; }
            }
        }
    }
}