namespace org.mycompany.customers.cronus.sales.item.certification;

page 50101 "Furniture Certificate Card"
{
    PageType = Card;
    ApplicationArea = Basic, Suite;
    SourceTable = "Furniture Certificate";
    Caption = 'Furniture Certificate';
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Certificate';

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
                field(ExternalReference; Rec."External Reference")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies an external reference for the certificate.';
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = Basic, Suite;
                    MultiLine = true;
                    ToolTip = 'Specifies additional notes about the certificate.';
                }
            }
        }
        area(factboxes)
        {
            part(Assignments; "Certificate Item Assignments")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Certificate Code" = FIELD("Code");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RecalculateStatus)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Recalculate Status';
                Image = Recalculate;
                ToolTip = 'Recalculates the status of the certificate based on validity dates.';

                trigger OnAction()
                var
                    CertificateMgt: Codeunit "Furniture Certificate Mgt";
                begin
                    Rec.Status := CertificateMgt.EvaluateStatus(Rec);
                    Rec.Modify(true);
                end;
            }
        }
    }
}
