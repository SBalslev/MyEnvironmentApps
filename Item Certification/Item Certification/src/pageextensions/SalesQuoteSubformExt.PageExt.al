namespace org.mycompany.customers.cronus.sales.item.certification;

using Microsoft.Sales.Document;

pageextension 50103 "Sales Quote Subform Ext" extends "Sales Quote Subform"
{
    actions
    {
        addlast(processing)
        {
            action(ViewItemCertificates)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'View Item Certificates';
                Image = Certificate;
                ToolTip = 'View the certificates assigned to this item.';
                Enabled = Rec.Type = Rec.Type::Item;

                trigger OnAction()
                var
                    AssignmentRec: Record "Furniture Cert. Assignment";
                begin
                    if Rec.Type <> Rec.Type::Item then
                        exit;

                    if Rec."No." = '' then
                        Error('Please select an item first.');

                    AssignmentRec.SetRange("Item No.", Rec."No.");
                    PAGE.RunModal(PAGE::"Item Certificates", AssignmentRec);
                end;
            }
        }
    }
}
