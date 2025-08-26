page 50117 "SBX SR Category Card"
{
    Caption = 'Service Request Category';
    PageType = Card;
    SourceTable = "SBX Service Request Category";
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
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