page 50110 "SBX SR Category List"
{
    Caption = 'Service Request Categories';
    PageType = List;
    SourceTable = "SBX Service Request Category";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageID = "SBX SR Category Card";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Default Priority"; Rec."Default Priority") { ApplicationArea = All; }
                field("Default Billable"; Rec."Default Billable") { ApplicationArea = All; }
                field("Billing Mode Override"; Rec."Billing Mode Override") { ApplicationArea = All; }
            }
        }
    }
}
