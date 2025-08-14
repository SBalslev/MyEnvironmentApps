page 50102 "Unit List"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = Unit;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Property ID"; Rec."Property ID") { ApplicationArea = All; }
                field("Unit Label"; Rec."Unit Label") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field(Bedrooms; Rec.Bedrooms) { ApplicationArea = All; }
                field("Market Rent"; Rec."Market Rent") { ApplicationArea = All; }
            }
        }
    }
}

page 50103 "Tenant List"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = Tenant;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("First Name"; Rec."First Name") { ApplicationArea = All; }
                field("Last Name"; Rec."Last Name") { ApplicationArea = All; }
                field(Email; Rec.Email) { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
            }
        }
    }
}

page 50104 "Lease List"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = Lease;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Unit No."; Rec."Unit No.") { ApplicationArea = All; }
                field("Tenant No."; Rec."Tenant No.") { ApplicationArea = All; }
                field("Start Date"; Rec."Start Date") { ApplicationArea = All; }
                field("End Date"; Rec."End Date") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Rent Amount"; Rec."Rent Amount") { ApplicationArea = All; }
            }
        }
    }
}

page 50105 "Service Request List"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Service Request";
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field(Priority; Rec.Priority) { ApplicationArea = All; }
                field(Category; Rec.Category) { ApplicationArea = All; }
                field(Title; Rec.Title) { ApplicationArea = All; }
                field("Opened At"; Rec."Opened At") { ApplicationArea = All; }
                field("SLA Due At"; Rec."SLA Due At") { ApplicationArea = All; }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(Triage)
            {
                Caption = 'Triage';
                ApplicationArea = All;
                Enabled = Rec.Status = Rec.Status::New;
                trigger OnAction()
                var
                    SRMgt: Codeunit "Service Request Mgt";
                begin
                    SRMgt.UpdateStatus(Rec, Rec.Status::Triaged, 'Triaged');
                    CurrPage.Update(false);
                end;
            }
            action(Assign)
            {
                Caption = 'Assign';
                ApplicationArea = All;
                Enabled = Rec.Status = Rec.Status::Triaged;
                trigger OnAction()
                var
                    SRMgt: Codeunit "Service Request Mgt";
                begin
                    SRMgt.UpdateStatus(Rec, Rec.Status::Assigned, 'Assigned');
                    CurrPage.Update(false);
                end;
            }
            action(StartProgress)
            {
                Caption = 'Start';
                ApplicationArea = All;
                Enabled = Rec.Status = Rec.Status::Assigned;
                trigger OnAction()
                var
                    SRMgt: Codeunit "Service Request Mgt";
                begin
                    SRMgt.UpdateStatus(Rec, Rec.Status::"In Progress", 'Work started');
                    CurrPage.Update(false);
                end;
            }
            action(Hold)
            {
                Caption = 'Hold';
                ApplicationArea = All;
                Enabled = (Rec.Status = Rec.Status::Triaged) or (Rec.Status = Rec.Status::Assigned) or (Rec.Status = Rec.Status::"In Progress");
                trigger OnAction()
                var
                    SRMgt: Codeunit "Service Request Mgt";
                begin
                    SRMgt.UpdateStatus(Rec, Rec.Status::"On Hold", 'On hold');
                    CurrPage.Update(false);
                end;
            }
            action(Complete)
            {
                Caption = 'Complete';
                ApplicationArea = All;
                Enabled = (Rec.Status = Rec.Status::"In Progress") or (Rec.Status = Rec.Status::Assigned);
                trigger OnAction()
                var
                    SRMgt: Codeunit "Service Request Mgt";
                begin
                    SRMgt.UpdateStatus(Rec, Rec.Status::Completed, 'Completed');
                    CurrPage.Update(false);
                end;
            }
            action(Cancel)
            {
                Caption = 'Cancel';
                ApplicationArea = All;
                Enabled = (Rec.Status <> Rec.Status::Completed) and (Rec.Status <> Rec.Status::Cancelled);
                trigger OnAction()
                var
                    SRMgt: Codeunit "Service Request Mgt";
                begin
                    SRMgt.UpdateStatus(Rec, Rec.Status::Cancelled, 'Cancelled');
                    CurrPage.Update(false);
                end;
            }
        }
    }
}

page 50106 "Service Request Updates"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Service Request Update";
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; }
                field("Service Request No."; Rec."Service Request No.") { ApplicationArea = All; }
                field("Old Status"; Rec."Old Status") { ApplicationArea = All; }
                field("New Status"; Rec."New Status") { ApplicationArea = All; }
                field(Note; Rec.Note) { ApplicationArea = All; }
                field("Changed By"; Rec."Changed By") { ApplicationArea = All; }
                field("Change Time"; Rec."Change Time") { ApplicationArea = All; }
            }
        }
    }
}
