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
                field("No."; Rec."No.") { ApplicationArea = All; ToolTip = 'Unique identifier of the service request.'; }
                field(Status; Rec.Status) { ApplicationArea = All; ToolTip = 'Current status of the service request.'; }
                field(Priority; Rec.Priority) { ApplicationArea = All; ToolTip = 'Priority assigned to the request.'; }
                field("Property Code"; Rec."Property Code") { ApplicationArea = All; ToolTip = 'Property associated with the request.'; }
                field("Unit Code"; Rec."Unit Code") { ApplicationArea = All; ToolTip = 'Unit associated with the request.'; }
                field("Lease No."; Rec."Lease No.") { ApplicationArea = All; ToolTip = 'Related lease number (if any).'; }
                field("Customer Name"; Rec."Customer Name") { ApplicationArea = All; ToolTip = 'Customer name derived from the related lease or customer.'; }
                field("Category Code"; Rec."Category Code") { ApplicationArea = All; ToolTip = 'Category classifying the type of request.'; }
                field("Open DateTime"; Rec."Open DateTime") { ApplicationArea = All; ToolTip = 'Date and time when the request was opened.'; }
            }
        }
    }
}
