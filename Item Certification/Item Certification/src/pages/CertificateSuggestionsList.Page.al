namespace org.mycompany.customers.cronus.sales.item.certification;

page 50106 "Certificate Suggestions List"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Certificate Suggestion";
    SourceTableTemporary = true;
    Caption = 'Suggested Certificates';
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Selected; Rec.Selected)
                {
                    ApplicationArea = All;
                    Caption = 'Apply';
                    ToolTip = 'Specifies whether this certificate should be assigned to the item.';
                }
                field(CertificateCode; Rec."Certificate Code")
                {
                    ApplicationArea = All;
                    Caption = 'Certificate Code';
                    ToolTip = 'Specifies the suggested certificate code.';
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        Certificate: Record "Furniture Certificate";
                    begin
                        if Certificate.Get(Rec."Certificate Code") then
                            Page.RunModal(Page::"Furniture Certificate Card", Certificate);
                    end;
                }
                field(CertificateDescription; Rec."Certificate Description")
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies the description of the suggested certificate.';
                    Editable = false;
                }
                field(CertificateType; Rec."Certificate Type")
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    ToolTip = 'Specifies the type of certificate.';
                    Editable = false;
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = All;
                    Caption = 'Reason';
                    ToolTip = 'Specifies why this certificate is recommended for the item.';
                    Editable = false;
                }
            }
        }
    }

    procedure LoadSuggestions(var CertificateSuggestion: Record "Certificate Suggestion")
    begin
        Rec.Copy(CertificateSuggestion, true);
        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;

    procedure GetSuggestions(var CertificateSuggestion: Record "Certificate Suggestion")
    begin
        CertificateSuggestion.Copy(Rec, true);
    end;
}
