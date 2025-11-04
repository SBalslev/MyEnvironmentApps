namespace org.mycompany.customers.cronus.sales.item.certification;

using Microsoft.Inventory.Item;
using System.AI;

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
                    ApplicationArea = Basic, Suite;
                    SubPageLink = "Item No." = FIELD("No.");
                    UpdatePropagation = Both;
                }
            }
        }
    }

    actions
    {
        addlast(Prompting)
        {
            action(SuggestCertificates)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Suggest certificates';
                Image = Sparkle;
                ToolTip = 'Use Copilot to suggest appropriate certificates for this item based on its name, description, and your requirements.';
                Visible = IsCapabilityRegistered;

                trigger OnAction()
                var
                    CopilotPage: Page "Certificate Copilot";
                begin
                    CopilotPage.SetItemInfo(Rec);
                    CopilotPage.RunModal();
                    CurrPage.Update(false);
                end;
            }
        }

        addlast(Navigation)
        {
            action(ManageCertificates)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Manage Certificates';
                Image = DocumentEdit;
                ToolTip = 'Manage the certificates assigned to this item.';

                trigger OnAction()
                var
                    AssignmentRec: Record "Furniture Cert. Assignment";
                    AssignmentPage: Page "Item Certificates";
                begin
                    AssignmentRec.SetRange("Item No.", Rec."No.");
                    AssignmentPage.SetTableView(AssignmentRec);
                    AssignmentPage.RunModal();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        CopilotCapability: Codeunit "Copilot Capability";
    begin
        IsCapabilityRegistered := CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::"Suggest Item Certificates");
    end;

    var
        IsCapabilityRegistered: Boolean;
}
