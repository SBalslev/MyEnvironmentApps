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
                field("Version No."; Rec."Version No.") { ApplicationArea = All; }
                field("Effective Start Date"; Rec."Effective Start Date") { ApplicationArea = All; }
                field("Effective End Date"; Rec."Effective End Date") { ApplicationArea = All; }
                field("Base Rent Amount"; Rec."Base Rent Amount") { ApplicationArea = All; }
            }
        }
    }
}
