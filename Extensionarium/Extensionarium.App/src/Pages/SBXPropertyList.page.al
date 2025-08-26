page 50101 "SBX Property List"
{
    Caption = 'Properties';
    PageType = List;
    ApplicationArea = All;
    SourceTable = "SBX Property";
    UsageCategory = Lists;
    CardPageID = "SBX Property Card";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Name; Rec.Name) { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Portfolio/Region Code"; Rec."Portfolio/Region Code") { ApplicationArea = All; }
            }
        }
    }

    // Card navigation now via automatic lookup (CardPageID); explicit Card action removed.
}
