page 50106 "SBX Service Request Card"
{
    Caption = 'Service Request';
    PageType = Card;
    SourceTable = "SBX Service Request";
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field(Priority; Rec.Priority) { ApplicationArea = All; }
                field("Category Code"; Rec."Category Code") { ApplicationArea = All; }
                field("Property Code"; Rec."Property Code") { ApplicationArea = All; }
                field("Unit Code"; Rec."Unit Code") { ApplicationArea = All; }
                field("Lease No."; Rec."Lease No.") { ApplicationArea = All; }
                field("Customer Name"; Rec."Customer Name") { ApplicationArea = All; Editable = false; }
            }
            group(Details)
            {
                field(Source; Rec.Source) { ApplicationArea = All; }
                field("Reported By"; Rec."Reported By") { ApplicationArea = All; }
                field(Billable; Rec.Billable) { ApplicationArea = All; }
                field("Billable Amount"; Rec."Billable Amount") { ApplicationArea = All; }
            }
            group(Times)
            {
                field("Open DateTime"; Rec."Open DateTime") { ApplicationArea = All; }
                field("Respond By DateTime"; Rec."Respond By DateTime") { ApplicationArea = All; }
                field("Resolved DateTime"; Rec."Resolved DateTime") { ApplicationArea = All; }
                field("Closed DateTime"; Rec."Closed DateTime") { ApplicationArea = All; }
            }
            group(Notes)
            {
                field("Description Text"; Rec.Description) { ApplicationArea = All; MultiLine = true; Caption = 'Description'; }
                field("Resolution Notes"; Rec."Resolution Notes") { ApplicationArea = All; MultiLine = true; }
            }
        }
    }
}
