namespace org.mycompany.customers.cronus.sales.item.certification;

page 50100 "Furniture Certificates"
{
    PageType = List;
    ApplicationArea = Basic, Suite;
    SourceTable = "Furniture Certificate";
    Caption = 'Furniture Certificates';
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec."Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the unique code for the furniture certificate.';
                }
                field(Description; Rec."Description")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the description of the furniture certificate.';
                }
                field(CertificateType; Rec."Certificate Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of the furniture certificate.';
                }
                field(IssuingAuthority; Rec."Issuing Authority")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the authority that issued the certificate.';
                }
                field(ValidFrom; Rec."Valid From")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date from which the certificate is valid.';
                }
                field(ValidTo; Rec."Valid To")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date until which the certificate is valid.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the current status of the certificate.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Card)
            {
                ApplicationArea = Basic, Suite;
                RunObject = Page "Furniture Certificate Card";
                RunPageLink = Code = FIELD(Code);
                RunPageMode = View;
                ToolTip = 'Opens the certificate card for the selected certificate.';
                Image = Card;
            }
        }
    }
}
