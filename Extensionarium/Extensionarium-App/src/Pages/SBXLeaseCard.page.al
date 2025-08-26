page 50113 "SBX Lease Card"
{
    Caption = 'Lease';
    PageType = Card;
    SourceTable = "SBX Lease";
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.") { ApplicationArea = All; ToolTip = 'Unique identifier of the lease.'; }
                field("Customer Name"; Rec."Customer Name") { ApplicationArea = All; Editable = false; ToolTip = 'Name of the customer associated with this lease (read-only).'; }
                field("Property Code"; Rec."Property Code") { ApplicationArea = All; ToolTip = 'Code of the related property.'; }
                field("Unit Code"; Rec."Unit Code") { ApplicationArea = All; ToolTip = 'Code of the unit associated with this lease.'; }
                field(Status; Rec.Status) { ApplicationArea = All; ToolTip = 'Current status of the lease.'; }
                field("Start Date"; Rec."Start Date") { ApplicationArea = All; ToolTip = 'Date the lease starts.'; }
                field("End Date"; Rec."End Date") { ApplicationArea = All; ToolTip = 'Planned end date of the lease.'; }
                field("Signed Date"; Rec."Signed Date") { ApplicationArea = All; ToolTip = 'Date the lease document was signed.'; }
                field("Signed Document"; Rec."Signed Document") { ApplicationArea = All; ToolTip = 'Binary document or link representing the signed lease.'; }
            }
            group(Billing)
            {
                field("Billing Start Date"; Rec."Billing Start Date") { ApplicationArea = All; ToolTip = 'First date charges begin to accrue.'; }
                field("Billing Frequency Interval"; Rec."Billing Frequency Interval") { ApplicationArea = All; ToolTip = 'Interval number for recurring billing (e.g. every 1 month).'; }
                field("Frequency Type"; Rec."Frequency Type") { ApplicationArea = All; ToolTip = 'Time unit used with the frequency interval (e.g. Month).'; }
                field("Base Rent Amount"; Rec."Base Rent Amount") { ApplicationArea = All; ToolTip = 'Standard recurring rent amount for the lease.'; }
                field("Deposit Amount"; Rec."Deposit Amount") { ApplicationArea = All; ToolTip = 'Security deposit amount collected.'; }
                field("Termination Notice Days"; Rec."Termination Notice Days") { ApplicationArea = All; ToolTip = 'Number of days notice required before termination.'; }
            }
            group(Audit)
            {
                field("Current Version No."; Rec."Current Version No.") { ApplicationArea = All; Editable = false; ToolTip = 'Latest amendment version number of this lease.'; }
                field("Last Invoiced Through Date"; Rec."Last Invoiced Through Date") { ApplicationArea = All; Editable = false; ToolTip = 'Date through which charges have been invoiced.'; }
            }
            part(Charges; "SBX Recurring Charge Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Lease No." = FIELD("No.");
            }
            part(Deposits; "SBX Deposit Ledger Entries")
            {
                ApplicationArea = All;
                SubPageLink = "Lease No." = FIELD("No.");
            }
            part(Amendments; "SBX Lease Amend Hist")
            {
                ApplicationArea = All;
                SubPageLink = "Lease No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Activate)
            {
                Caption = 'Activate';
                ApplicationArea = All;
                Image = Start;
                ToolTip = 'Activate this draft lease.';
                Enabled = (Rec.Status = Rec.Status::Draft);
                trigger OnAction()
                var
                    LeaseMgt: Codeunit "SBX Lease Mgt.";
                begin
                    LeaseMgt.ActivateLease(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(Terminate)
            {
                Caption = 'Terminate';
                ApplicationArea = All;
                Image = Stop;
                ToolTip = 'Terminate this active lease.';
                Enabled = (Rec.Status = Rec.Status::Active);
                trigger OnAction()
                var
                    LeaseMgt: Codeunit "SBX Lease Mgt.";
                begin
                    LeaseMgt.TerminateLease(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
