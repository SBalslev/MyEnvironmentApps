namespace org.mycompany.customers.cronus.sales.item.certification;

using Microsoft.Purchases.Document;

tableextension 50100 "Purchase Header Cert Ext" extends "Purchase Header"
{
    fields
    {
        field(50100; "Certificate Violations"; Text[250])
        {
            Caption = 'Certificate Violations';
            DataClassification = CustomerContent;
        }
        field(50101; "Alt. Vendor Recommendation"; Text[250])
        {
            Caption = 'Alternative Vendor Recommendation';
            DataClassification = CustomerContent;
        }
    }
}
