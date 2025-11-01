namespace org.mycompany.customers.cronus.sales.item.certification;

table 50100 "Furniture Certificate"
{
    Caption = 'Furniture Certificate';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Certificate Type"; Enum "Furniture Certificate Type")
        {
            Caption = 'Certificate Type';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                EnsureDateRangeIsConsistent();
            end;
        }
        field(4; "Issuing Authority"; Text[100])
        {
            Caption = 'Issuing Authority';
            DataClassification = CustomerContent;
        }
        field(5; "Valid From"; Date)
        {
            Caption = 'Valid From';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                EnsureDateRangeIsConsistent();
            end;
        }
        field(6; "Valid To"; Date)
        {
            Caption = 'Valid To';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                EnsureDateRangeIsConsistent();
            end;
        }
        field(7; Status; Enum "Furniture Certificate Status")
        {
            Caption = 'Status';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(8; "External Reference"; Text[50])
        {
            Caption = 'External Reference';
            DataClassification = CustomerContent;
        }
        field(9; Notes; Text[250])
        {
            Caption = 'Notes';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
        key(TypeIdx; "Certificate Type", Status)
        {
        }
    }

    trigger OnInsert()
    var
        CertificateMgt: Codeunit "Furniture Certificate Mgt";
    begin
        EnsureDateRangeIsConsistent();
        Status := CertificateMgt.EvaluateStatus(Rec);
    end;

    trigger OnModify()
    var
        CertificateMgt: Codeunit "Furniture Certificate Mgt";
    begin
        EnsureDateRangeIsConsistent();
        Status := CertificateMgt.EvaluateStatus(Rec);
    end;

    trigger OnDelete()
    var
        Assignment: Record "Furniture Cert. Assignment";
    begin
        Assignment.SetRange("Certificate Code", "Code");
        if not Assignment.IsEmpty() then
            Assignment.DeleteAll();
    end;

    local procedure EnsureDateRangeIsConsistent()
    begin
        if ("Valid From" <> 0D) and ("Valid To" <> 0D) and ("Valid From" > "Valid To") then
            Error('Valid From must be on or before Valid To.');
    end;
}
