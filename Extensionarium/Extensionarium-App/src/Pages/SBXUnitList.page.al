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
                field("Property Code"; Rec."Property Code") { ApplicationArea = All; }
                field("Unit Code"; Rec."Unit Code") { ApplicationArea = All; }
                field("Unit Type"; Rec."Unit Type") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Area"; Rec."Area") { ApplicationArea = All; }
            }
        }
    }
}
