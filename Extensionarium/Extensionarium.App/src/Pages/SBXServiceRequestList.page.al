page 50105 "SBX Service Request List"
{
    Caption = 'Service Requests';
    PageType = List;
    SourceTable = "SBX Service Request";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageID = "SBX Service Request Card";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field(Priority; Rec.Priority) { ApplicationArea = All; }
                field("Property Code"; Rec."Property Code") { ApplicationArea = All; }
                field("Unit Code"; Rec."Unit Code") { ApplicationArea = All; }
                field("Lease No."; Rec."Lease No.") { ApplicationArea = All; }
                field("Customer Name"; Rec."Customer Name") { ApplicationArea = All; }
                field("Category Code"; Rec."Category Code") { ApplicationArea = All; }
                field("Open DateTime"; Rec."Open DateTime") { ApplicationArea = All; }
            }
        }
    }
}
