namespace org.mycompany.customers.cronus.sales.item.certification;

using Microsoft.Purchases.Document;

pageextension 50106 "Purchase Order Cert Ext" extends "Purchase Order"
{
    layout
    {
        addlast(content)
        {
            group("Certificate Recommendations")
            {
                Caption = 'Certificate Recommendations';

                field(CertificateViolations; Rec."Certificate Violations")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies any certificate violations found for items in this purchase order.';
                    MultiLine = true;
                }
                field(AlternativeVendorRecommendation; Rec."Alt. Vendor Recommendation")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies alternative vendor recommendations based on certificate requirements.';
                    MultiLine = true;
                }
            }
        }
    }
}
