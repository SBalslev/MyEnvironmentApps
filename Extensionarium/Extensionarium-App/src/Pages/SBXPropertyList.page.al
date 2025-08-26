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
                field(Code; Rec.Code) { ApplicationArea = All; ToolTip = 'Unique property code.'; }
                field(Name; Rec.Name) { ApplicationArea = All; ToolTip = 'Name of the property.'; }
                field(Status; Rec.Status) { ApplicationArea = All; ToolTip = 'Operational status of the property.'; }
                field("Portfolio/Region Code"; Rec."Portfolio/Region Code") { ApplicationArea = All; ToolTip = 'Portfolio or region grouping code.'; }
            }
        }
    }

    // Card navigation now via automatic lookup (CardPageID); explicit Card action removed.
}
