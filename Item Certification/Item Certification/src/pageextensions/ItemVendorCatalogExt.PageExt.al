namespace org.mycompany.customers.cronus.sales.item.certification;

using Microsoft.Inventory.Item.Catalog;
using Microsoft.Purchases.Vendor;

pageextension 50107 "Item Vendor Catalog Ext" extends "Item Vendor Catalog"
{
    layout
    {
        addafter("Vendor No.")
        {
            field("Vendor Name"; VendorName)
            {
                ApplicationArea = Planning;
                Caption = 'Vendor Name';
                ToolTip = 'Specifies the name of the vendor.';
                Editable = false;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        VendorName := GetVendorName();
    end;

    local procedure GetVendorName(): Text[100]
    var
        Vendor: Record Vendor;
    begin
        if Vendor.Get(Rec."Vendor No.") then
            exit(Vendor.Name);

        exit('');
    end;

    var
        VendorName: Text[100];
}
