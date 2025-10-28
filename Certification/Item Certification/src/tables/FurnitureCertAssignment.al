table 50101 "Furniture Cert. Assignment"
{
    Caption = 'Furniture Certificate Assignment';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
            DataClassification = CustomerContent;
        }
        field(2; "Certificate Code"; Code[20])
        {
            Caption = 'Certificate Code';
            TableRelation = "Furniture Certificate"."Code";
            DataClassification = CustomerContent;
        }
        field(3; "Valid From"; Date)
        {
            Caption = 'Valid From';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                EnsureDateRangeIsConsistent();
            end;
        }
        field(4; "Valid To"; Date)
        {
            Caption = 'Valid To';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                EnsureDateRangeIsConsistent();
            end;
        }
        field(5; "Assignment Status"; Enum "Furniture Certificate Status")
        {
            Caption = 'Assignment Status';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Furniture Certificate".Status WHERE(Code = FIELD("Certificate Code")));
        }
        field(6; "Certificate Type"; Enum "Furniture Certificate Type")
        {
            Caption = 'Certificate Type';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Furniture Certificate"."Certificate Type" WHERE(Code = FIELD("Certificate Code")));
        }
        field(10; "Created By"; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(11; "Created At"; DateTime)
        {
            Caption = 'Created At';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Item No.", "Certificate Code")
        {
            Clustered = true;
        }
        key(ItemDateIdx; "Item No.", "Valid From")
        {
        }
    }

    trigger OnInsert()
    var
        CertificateMgt: Codeunit "Furniture Certificate Mgt";
    begin
        if "Created At" = 0DT then
            "Created At" := CurrentDateTime;
        if "Created By" = '' then
            "Created By" := Format(UserSecurityId());

        CertificateMgt.InitialiseAssignmentDates(Rec);
        CertificateMgt.ValidateAssignment(Rec);
    end;

    trigger OnModify()
    var
        CertificateMgt: Codeunit "Furniture Certificate Mgt";
    begin
        CertificateMgt.ValidateAssignment(Rec);
    end;

    local procedure EnsureDateRangeIsConsistent()
    begin
        if ("Valid From" <> 0D) and ("Valid To" <> 0D) and ("Valid From" > "Valid To") then
            Error('Valid To must fall on or after Valid From.');
    end;
}
