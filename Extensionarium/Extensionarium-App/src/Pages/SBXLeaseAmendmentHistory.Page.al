// Renamed file to satisfy AA0215 (was SBXLeaseAmendmentHistoryList.page.al)
page 50120 "SBX Lease Amendment History"
{
    Caption = 'Lease Amendment History';
    PageType = List;
    SourceTable = "SBX Lease Amendment History";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; ToolTip = 'Sequential entry number of the amendment.'; }
                field("Lease No."; Rec."Lease No.") { ApplicationArea = All; ToolTip = 'Lease impacted by the amendment.'; }
                field("Version No."; Rec."Version No.") { ApplicationArea = All; ToolTip = 'Amendment version number.'; }
                field("Effective Start Date"; Rec."Effective Start Date") { ApplicationArea = All; ToolTip = 'Date from which the amendment takes effect.'; }
                field("Effective End Date"; Rec."Effective End Date") { ApplicationArea = All; ToolTip = 'Date the amendment ceases to be effective.'; }
                field("Base Rent Amount"; Rec."Base Rent Amount") { ApplicationArea = All; ToolTip = 'Base rent amount in this amendment version.'; }
                field("Deposit Amount"; Rec."Deposit Amount") { ApplicationArea = All; ToolTip = 'Deposit amount in this amendment version.'; }
            }
        }
    }
}
