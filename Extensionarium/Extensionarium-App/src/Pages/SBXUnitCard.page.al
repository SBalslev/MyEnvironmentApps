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
                field("Property Code"; Rec."Property Code") { ApplicationArea = All; }
                field("Unit Code"; Rec."Unit Code") { ApplicationArea = All; }
                field("Unit Type"; Rec."Unit Type") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field(Floor; Rec.Floor) { ApplicationArea = All; }
                field("Area"; Rec."Area") { ApplicationArea = All; }
                field("Out of Service Reason"; Rec."Out of Service Reason") { ApplicationArea = All; }
            }
        }
    }
}