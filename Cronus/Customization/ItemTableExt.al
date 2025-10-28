tableextension 50130 "Item Certificate Ext" extends Item
{
    fields
    {
        field(50130; "Certificate Information"; Text[250])
        {
            Caption = 'Certificate Information';
            DataClassification = CustomerContent;
        }
    }
}
