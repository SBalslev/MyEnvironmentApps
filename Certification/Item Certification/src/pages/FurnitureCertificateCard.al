page 50101 "Furniture Certificate Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Furniture Certificate";
    Caption = 'Furniture Certificate';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Certificate';

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
                field(ExternalReference; Rec."External Reference")
                {
                    ApplicationArea = All;
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
            }
        }
        area(factboxes)
        {
            part(Assignments; "Certificate Item Assignments")
            {
                ApplicationArea = All;
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
                ApplicationArea = All;
                Caption = 'Recalculate Status';
                Image = Recalculate;

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
