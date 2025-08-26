page 50116 "SBX Lease Charge Template Card"
{
    Caption = 'Lease Charge Template';
    PageType = Card;
    SourceTable = "SBX Lease Charge Template";
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code) { ApplicationArea = All; ToolTip = 'Unique code of the lease charge template.'; }
                field(Description; Rec.Description) { ApplicationArea = All; ToolTip = 'Description of the charge template.'; }
                field("Charge Type"; Rec."Charge Type") { ApplicationArea = All; ToolTip = 'Identifies the functional type of the charge.'; }
                field(Amount; Rec.Amount) { ApplicationArea = All; ToolTip = 'Default amount for the charge when applied.'; }
                field("Frequency Interval"; Rec."Frequency Interval") { ApplicationArea = All; ToolTip = 'Interval number for recurrence (e.g. 1 = every month).'; }
                field("Frequency Type"; Rec."Frequency Type") { ApplicationArea = All; ToolTip = 'Time unit of the recurrence (e.g. Month).'; }
                field("Dimension Behavior"; Rec."Dimension Behavior") { ApplicationArea = All; ToolTip = 'How to apply property/unit dimensions to generated lines.'; }
                field(Active; Rec.Active) { ApplicationArea = All; ToolTip = 'Specifies if the template is available for new charges.'; }
                field("Requires Meter"; Rec."Requires Meter") { ApplicationArea = All; ToolTip = 'Specifies if a meter reading is required before posting.'; }
                field(Formula; Rec.Formula) { ApplicationArea = All; ToolTip = 'Optional calculation formula for dynamic charges.'; }
            }
        }
    }
}