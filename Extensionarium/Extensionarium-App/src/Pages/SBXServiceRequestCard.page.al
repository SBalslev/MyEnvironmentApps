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
                field("No."; Rec."No.") { ApplicationArea = All; ToolTip = 'Unique identifier of the service request.'; }
                field(Status; Rec.Status) { ApplicationArea = All; ToolTip = 'Current status of the service request.'; }
                field(Priority; Rec.Priority) { ApplicationArea = All; ToolTip = 'Priority assigned to the request.'; }
                field("Category Code"; Rec."Category Code") { ApplicationArea = All; ToolTip = 'Category classifying the type of request.'; }
                field("Property Code"; Rec."Property Code") { ApplicationArea = All; ToolTip = 'Property associated with the request.'; }
                field("Unit Code"; Rec."Unit Code") { ApplicationArea = All; ToolTip = 'Unit associated with the request.'; }
                field("Lease No."; Rec."Lease No.") { ApplicationArea = All; ToolTip = 'Related lease number (if any).'; }
                field("Customer Name"; Rec."Customer Name") { ApplicationArea = All; Editable = false; ToolTip = 'Customer name derived from the related lease or customer number.'; }
            }
            group(Details)
            {
                field(Source; Rec.Source) { ApplicationArea = All; ToolTip = 'Origin/source of the service request.'; }
                field("Reported By"; Rec."Reported By") { ApplicationArea = All; ToolTip = 'Name of the person who reported the issue.'; }
                field(Billable; Rec.Billable) { ApplicationArea = All; ToolTip = 'Specifies if the work is billable.'; }
                field("Billable Amount"; Rec."Billable Amount") { ApplicationArea = All; ToolTip = 'Amount to bill for this request (if billable).'; }
            }
            group(Times)
            {
                field("Open DateTime"; Rec."Open DateTime") { ApplicationArea = All; ToolTip = 'Date and time when the request was opened.'; }
                field("Respond By DateTime"; Rec."Respond By DateTime") { ApplicationArea = All; ToolTip = 'Target date/time to respond.'; }
                field("Resolved DateTime"; Rec."Resolved DateTime") { ApplicationArea = All; ToolTip = 'Date/time when the request was resolved.'; }
                field("Closed DateTime"; Rec."Closed DateTime") { ApplicationArea = All; ToolTip = 'Date/time when the request was closed.'; }
            }
            group(Notes)
            {
                field("Description Text"; Rec.Description) { ApplicationArea = All; MultiLine = true; Caption = 'Description'; ToolTip = 'Detailed description of the issue.'; }
                field("Resolution Notes"; Rec."Resolution Notes") { ApplicationArea = All; MultiLine = true; ToolTip = 'Notes describing how the issue was resolved.'; }
            }
        }
    }
}
