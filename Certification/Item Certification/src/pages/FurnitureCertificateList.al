page 50100 "Furniture Certificates"
{
    PageType = List;
    ApplicationArea = All;
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
                    ApplicationArea = All;
                }
                field(Description; Rec."Description")
                {
                    ApplicationArea = All;
                }
                field(CertificateType; Rec."Certificate Type")
                {
                    ApplicationArea = All;
                }
                field(IssuingAuthority; Rec."Issuing Authority")
                {
                    ApplicationArea = All;
                }
                field(ValidFrom; Rec."Valid From")
                {
                    ApplicationArea = All;
                }
                field(ValidTo; Rec."Valid To")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
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
                ApplicationArea = All;
                RunObject = Page "Furniture Certificate Card";
                RunPageMode = Edit;
            }
        }
    }
}
