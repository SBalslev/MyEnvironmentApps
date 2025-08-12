page 50133 "Service Request Card"
{
    PageType = Card;
    SourceTable = "Service Request";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field(Priority; Rec.Priority) { ApplicationArea = All; }
                field(Category; Rec.Category) { ApplicationArea = All; }
                field(Title; Rec.Title) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; MultiLine = true; }
                field("Property ID"; Rec."Property ID") { ApplicationArea = All; }
                field("Unit No."; Rec."Unit No.") { ApplicationArea = All; }
                field("Lease No."; Rec."Lease No.") { ApplicationArea = All; }
                field("Tenant No."; Rec."Tenant No.") { ApplicationArea = All; }
                field("Opened At"; Rec."Opened At") { ApplicationArea = All; }
                field("SLA Due At"; Rec."SLA Due At") { ApplicationArea = All; }
                field("Closed At"; Rec."Closed At") { ApplicationArea = All; }
                field("Estimated Cost"; Rec."Estimated Cost") { ApplicationArea = All; }
                field("Actual Cost"; Rec."Actual Cost") { ApplicationArea = All; }
            }
            part(Timeline; "Service Request Timeline") { ApplicationArea = All; SubPageLink = "Service Request No." = field("No."); }
        }
    }
}
