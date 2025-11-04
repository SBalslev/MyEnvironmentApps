namespace org.mycompany.customers.cronus.sales.item.certification;

using Microsoft.Inventory.Item;

pageextension 50101 "Item List Certificate Ext" extends "Item List"
{
    actions
    {
        addlast(Navigation)
        {
            action(ViewCertificates)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'View Certificates';
                Image = List;
                ToolTip = 'View the certificates assigned to the selected item.';

                trigger OnAction()
                var
                    AssignmentRec: Record "Furniture Cert. Assignment";
                begin
                    AssignmentRec.SetRange("Item No.", Rec."No.");
                    PAGE.RunModal(PAGE::"Item Certificates", AssignmentRec);
                end;
            }
        }
    }
}
