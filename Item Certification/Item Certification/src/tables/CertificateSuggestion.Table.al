namespace org.mycompany.customers.cronus.sales.item.certification;

table 50102 "Certificate Suggestion"
{
    Caption = 'Certificate Suggestion';
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
        }
        field(2; "Certificate Code"; Code[20])
        {
            Caption = 'Certificate Code';
            TableRelation = "Furniture Certificate"."Code";
            DataClassification = SystemMetadata;
        }
        field(3; "Certificate Description"; Text[100])
        {
            Caption = 'Certificate Description';
            DataClassification = SystemMetadata;
        }
        field(4; "Certificate Type"; Enum "Furniture Certificate Type")
        {
            Caption = 'Certificate Type';
            DataClassification = SystemMetadata;
        }
        field(5; Reason; Text[250])
        {
            Caption = 'Reason';
            DataClassification = SystemMetadata;
        }
        field(6; Selected; Boolean)
        {
            Caption = 'Selected';
            DataClassification = SystemMetadata;
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
