page 50107 "SBX Lease Charge Template List"
{
    Caption = 'Lease Charge Templates';
    PageType = List;
    SourceTable = "SBX Lease Charge Template";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageID = "SBX Lease Charge Template Card";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code) { ApplicationArea = All; ToolTip = 'Unique code of the lease charge template.'; }
                field(Description; Rec.Description) { ApplicationArea = All; ToolTip = 'Description of the charge template.'; }
                field("Charge Type"; Rec."Charge Type") { ApplicationArea = All; ToolTip = 'Identifies the functional type of the charge.'; }
                field(Amount; Rec.Amount) { ApplicationArea = All; ToolTip = 'Default amount for the charge when applied.'; }
                field("Frequency Interval"; Rec."Frequency Interval") { ApplicationArea = All; ToolTip = 'Interval number for recurrence (e.g. 1 = every month).'; }
                field("Frequency Type"; Rec."Frequency Type") { ApplicationArea = All; ToolTip = 'Time unit of the recurrence (e.g. Month).'; }
                field(Active; Rec.Active) { ApplicationArea = All; ToolTip = 'Specifies if the template is available for new charges.'; }
            }
        }
    }
}
