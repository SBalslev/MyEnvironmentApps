page 50115 "SBX Unit Card"
{
    Caption = 'Unit';
    PageType = Card;
    SourceTable = "SBX Unit";
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Property Code"; Rec."Property Code") { ApplicationArea = All; ToolTip = 'Code of the property this unit belongs to.'; }
                field("Unit Code"; Rec."Unit Code") { ApplicationArea = All; ToolTip = 'Identifier of the unit.'; }
                field("Unit Type"; Rec."Unit Type") { ApplicationArea = All; ToolTip = 'Classification of the unit.'; }
                field(Status; Rec.Status) { ApplicationArea = All; ToolTip = 'Operational status of the unit.'; }
                field(Floor; Rec.Floor) { ApplicationArea = All; ToolTip = 'Floor or level where the unit is located.'; }
                field("Area"; Rec."Area") { ApplicationArea = All; ToolTip = 'Measured area of the unit.'; }
                field("Out of Service Reason"; Rec."Out of Service Reason") { ApplicationArea = All; ToolTip = 'Reason why the unit is out of service (if applicable).'; }
            }
        }
    }
}