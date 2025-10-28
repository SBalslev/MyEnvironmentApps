pageextension 50130 "Item Card Certificate Ext" extends "Item Card"
{
    layout
    {
        addafter(Invoicing)
        {
            group(Certificate)
            {
                Caption = 'Certificate';
                
                field("Certificate Information"; Rec."Certificate Information")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies certificate information for this item.';
                }
            }
        }
    }
}
