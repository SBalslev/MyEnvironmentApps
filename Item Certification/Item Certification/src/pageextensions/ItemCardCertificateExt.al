pageextension 50100 "Item Card Certificate Ext" extends "Item Card"
{
    layout
    {
        addlast(Content)
        {
            group("Certificate Assignments")
            {
                Caption = 'Certificate Assignments';

                part(ItemCertificates; "Item Certificate Assignments")
                {
                    ApplicationArea = All;
                    SubPageLink = "Item No." = FIELD("No.");
                    UpdatePropagation = Both;
                }
            }
        }
    }

    actions
    {
        addlast(Navigation)
        {
            action(ManageCertificates)
            {
                ApplicationArea = All;
                Caption = 'Manage Certificates';
                Image = DocumentEdit;

                trigger OnAction()
                var
                    AssignmentPage: Page "Item Certificates";
                    AssignmentRec: Record "Furniture Cert. Assignment";
                begin
                    AssignmentRec.SetRange("Item No.", Rec."No.");
                    AssignmentPage.SetTableView(AssignmentRec);
                    AssignmentPage.RunModal();
                end;
            }
        }
    }
}
