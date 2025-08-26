page 50104 "SBX Lease List"
{
    Caption = 'Leases';
    PageType = List;
    ApplicationArea = All;
    SourceTable = "SBX Lease";
    UsageCategory = Lists;
    CardPageID = "SBX Lease Card";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All; ToolTip = 'Lease number (auto-assigned).'; }
                field("Customer Name"; Rec."Customer Name") { ApplicationArea = All; ToolTip = 'Name of the customer (tenant) linked to the lease.'; }
                field("Property Code"; Rec."Property Code") { ApplicationArea = All; ToolTip = 'Property this lease belongs to.'; }
                field("Unit Code"; Rec."Unit Code") { ApplicationArea = All; ToolTip = 'Specific unit covered by the lease.'; }
                field(Status; Rec.Status) { ApplicationArea = All; ToolTip = 'Current lifecycle status of the lease.'; }
                field("Start Date"; Rec."Start Date") { ApplicationArea = All; ToolTip = 'Contracted lease start date.'; }
                field("End Date"; Rec."End Date") { ApplicationArea = All; ToolTip = 'Scheduled lease end date.'; }
                field("Base Rent Amount"; Rec."Base Rent Amount") { ApplicationArea = All; ToolTip = 'Current base rent amount for billing interval.'; }
            }
        }
    }
}
