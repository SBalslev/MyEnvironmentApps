// Renamed from SBXLeaseAmendmentHistoryListPart.page.al to satisfy AA0215
page 50111 "SBX Lease Amend Hist"
{
    Caption = 'Lease Amendments';
    PageType = ListPart;
    SourceTable = "SBX Lease Amendment History";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Version No."; Rec."Version No.") { ApplicationArea = All; ToolTip = 'Amendment version number.'; }
                field("Effective Start Date"; Rec."Effective Start Date") { ApplicationArea = All; ToolTip = 'Date from which the amendment takes effect.'; }
                field("Effective End Date"; Rec."Effective End Date") { ApplicationArea = All; ToolTip = 'Date the amendment ceases to be effective.'; }
                field("Base Rent Amount"; Rec."Base Rent Amount") { ApplicationArea = All; ToolTip = 'Base rent amount in this amendment version.'; }
            }
        }
    }
}
