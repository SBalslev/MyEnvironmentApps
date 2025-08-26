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
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Customer Name"; Rec."Customer Name") { ApplicationArea = All; Editable = false; ToolTip = 'Name of the customer associated with this lease (read-only).'; }
                field("Property Code"; Rec."Property Code") { ApplicationArea = All; }
                field("Unit Code"; Rec."Unit Code") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Start Date"; Rec."Start Date") { ApplicationArea = All; }
                field("End Date"; Rec."End Date") { ApplicationArea = All; }
                field("Signed Date"; Rec."Signed Date") { ApplicationArea = All; }
                field("Signed Document"; Rec."Signed Document") { ApplicationArea = All; }
            }
            group(Billing)
            {
                field("Billing Start Date"; Rec."Billing Start Date") { ApplicationArea = All; }
                field("Billing Frequency Interval"; Rec."Billing Frequency Interval") { ApplicationArea = All; }
                field("Frequency Type"; Rec."Frequency Type") { ApplicationArea = All; }
                field("Base Rent Amount"; Rec."Base Rent Amount") { ApplicationArea = All; }
                field("Deposit Amount"; Rec."Deposit Amount") { ApplicationArea = All; }
                field("Termination Notice Days"; Rec."Termination Notice Days") { ApplicationArea = All; }
            }
            group(Audit)
            {
                field("Current Version No."; Rec."Current Version No.") { ApplicationArea = All; Editable = false; }
                field("Last Invoiced Through Date"; Rec."Last Invoiced Through Date") { ApplicationArea = All; Editable = false; }
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
