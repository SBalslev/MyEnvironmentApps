page 50103 "SBX Unit List"
{
    Caption = 'Units';
    PageType = List;
    ApplicationArea = All;
    SourceTable = "SBX Unit";
    UsageCategory = Lists;
    CardPageID = "SBX Unit Card";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Property Code"; Rec."Property Code") { ApplicationArea = All; ToolTip = 'Code of the property this unit belongs to.'; }
                field("Unit Code"; Rec."Unit Code") { ApplicationArea = All; ToolTip = 'Identifier of the unit.'; }
                field("Unit Type"; Rec."Unit Type") { ApplicationArea = All; ToolTip = 'Classification of the unit type.'; }
                field(Status; Rec.Status) { ApplicationArea = All; ToolTip = 'Current availability or operational status.'; }
                field("Area"; Rec."Area") { ApplicationArea = All; ToolTip = 'Measured area of the unit.'; }
            }
        }
    }
}
