page 50104 "Item Certificates"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Furniture Cert. Assignment";
    Caption = 'Item Certificates';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(CertificateCode; Rec."Certificate Code")
                {
                    ApplicationArea = All;
                }
                field(CertificateDescription; GetCertificateDescription())
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(CertificateType; Rec."Certificate Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ValidFrom; Rec."Valid From")
                {
                    ApplicationArea = All;
                }
                field(ValidTo; Rec."Valid To")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec."Assignment Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(OpenCertificate)
            {
                ApplicationArea = All;
                Caption = 'Open Certificate';
                Image = Document;

                trigger OnAction()
                var
                    Certificate: Record "Furniture Certificate";
                begin
                    if GetCertificate(Certificate) then
                        PAGE.RunModal(PAGE::"Furniture Certificate Card", Certificate);
                end;
            }
        }
    }

    local procedure GetCertificate(var Certificate: Record "Furniture Certificate"): Boolean
    begin
        if Certificate.Get(Rec."Certificate Code") then
            exit(true);

        Error('Certificate %1 is missing.', Rec."Certificate Code");
    end;

    local procedure GetCertificateDescription(): Text[100]
    var
        Certificate: Record "Furniture Certificate";
    begin
        if Certificate.Get(Rec."Certificate Code") then
            exit(Certificate."Description");

        exit('');
    end;
}
