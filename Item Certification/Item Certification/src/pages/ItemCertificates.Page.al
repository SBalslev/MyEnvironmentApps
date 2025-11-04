namespace org.mycompany.customers.cronus.sales.item.certification;

page 50104 "Item Certificates"
{
    PageType = List;
    ApplicationArea = Basic, Suite;
    SourceTable = "Furniture Cert. Assignment";
    Caption = 'Item Certificates';
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the item number for this certificate assignment.';
                }
                field(CertificateCode; Rec."Certificate Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the certificate code assigned to the item.';
                }
                field(CertificateDescription; GetCertificateDescription())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Certificate Description';
                    Editable = false;
                    ToolTip = 'Specifies the description of the assigned certificate.';
                }
                field(CertificateType; Rec."Certificate Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the type of the assigned certificate.';
                }
                field(ValidFrom; Rec."Valid From")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date from which the certificate assignment is valid.';
                }
                field(ValidTo; Rec."Valid To")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date until which the certificate assignment is valid.';
                }
                field(Status; Rec."Assignment Status")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the status of the certificate assignment.';
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
                ApplicationArea = Basic, Suite;
                Caption = 'Open Certificate';
                Image = Document;
                ToolTip = 'Opens the certificate card for the selected certificate.';

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
