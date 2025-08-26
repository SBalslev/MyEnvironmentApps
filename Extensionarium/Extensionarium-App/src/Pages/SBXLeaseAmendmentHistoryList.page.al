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
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; }
                field("Lease No."; Rec."Lease No.") { ApplicationArea = All; }
                field("Version No."; Rec."Version No.") { ApplicationArea = All; }
                field("Effective Start Date"; Rec."Effective Start Date") { ApplicationArea = All; }
                field("Effective End Date"; Rec."Effective End Date") { ApplicationArea = All; }
                field("Base Rent Amount"; Rec."Base Rent Amount") { ApplicationArea = All; }
                field("Deposit Amount"; Rec."Deposit Amount") { ApplicationArea = All; }
            }
        }
    }
}