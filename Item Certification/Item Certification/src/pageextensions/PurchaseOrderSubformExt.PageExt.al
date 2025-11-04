namespace org.mycompany.customers.cronus.sales.item.certification;

using Microsoft.Purchases.Document;
using Microsoft.Inventory.Item;
using Microsoft.Purchases.Vendor;
using Microsoft.Inventory.Item.Catalog;

pageextension 50105 "Purchase Order Subform Ext" extends "Purchase Order Subform"
{
    actions
    {
        addlast(processing)
        {
            action(OpenItemCard)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item';
                Image = Item;
                ToolTip = 'Open the item card for the selected item.';
                Enabled = Rec.Type = Rec.Type::Item;

                trigger OnAction()
                var
                    Item: Record Item;
                begin
                    if Rec.Type <> Rec.Type::Item then
                        exit;

                    if Rec."No." = '' then
                        Error('Please select an item first.');

                    if Item.Get(Rec."No.") then
                        PAGE.Run(PAGE::"Item Card", Item);
                end;
            }

            action(CheckCertificateValidity)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Check Certificate Validity';
                Image = Certificate;
                ToolTip = 'Check the validity of certificates assigned to this item.';
                Enabled = Rec.Type = Rec.Type::Item;

                trigger OnAction()
                var
                    CertificateMgt: Codeunit "Furniture Certificate Mgt";
                begin
                    if Rec.Type <> Rec.Type::Item then
                        exit;

                    if Rec."No." = '' then
                        Error('Please select an item first.');

                    CertificateMgt.CheckItemCertificateValidity(Rec."No.");
                end;
            }

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

            action(ItemVendors)
            {
                ApplicationArea = Planning;
                Caption = 'Vendors';
                Image = Vendor;
                ToolTip = 'View the list of vendors who can supply the item, and at which lead time.';
                Enabled = Rec.Type = Rec.Type::Item;
                RunObject = Page "Item Vendor Catalog";
                RunPageLink = "Item No." = field("No.");
                RunPageView = sorting("Item No.");
            }
        }
    }
}
