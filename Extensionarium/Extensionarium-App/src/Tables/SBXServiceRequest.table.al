table 50005 "SBX Service Request"
{
    Caption = 'Service Request';
    DataClassification = CustomerContent;
    DrillDownPageID = "SBX Service Request List";
    LookupPageID = "SBX Service Request List";

    fields
    {
        field(1; "No."; Code[20]) { Caption = 'No.'; }
        field(2; "Property Code"; Code[20]) { Caption = 'Property Code'; TableRelation = "SBX Property"; }
        field(3; "Unit Code"; Code[20]) { Caption = 'Unit Code'; TableRelation = "SBX Unit"."Unit Code" WHERE("Property Code" = FIELD("Property Code")); }
        field(4; "Lease No."; Code[20]) { Caption = 'Lease No.'; TableRelation = "SBX Lease"; }
        field(5; "Customer No."; Code[20]) { Caption = 'Customer No.'; TableRelation = Customer; }
        field(6; "Reported By"; Text[50]) { Caption = 'Reported By'; }
        field(7; Source; Enum "SBX SR Source") { Caption = 'Source'; }
        field(8; "Category Code"; Code[20]) { Caption = 'Category Code'; TableRelation = "SBX Service Request Category"; }
        field(9; Priority; Enum "SBX SR Priority") { Caption = 'Priority'; }
        field(10; Status; Enum "SBX SR Status") { Caption = 'Status'; }
        field(11; "Assigned User ID"; Code[50]) { Caption = 'Assigned User ID'; TableRelation = User."User Name"; }
        field(12; "Open DateTime"; DateTime) { Caption = 'Open DateTime'; }
        field(13; "Respond By DateTime"; DateTime) { Caption = 'Respond By DateTime'; }
        field(14; "Resolved DateTime"; DateTime) { Caption = 'Resolved DateTime'; }
        field(15; "Closed DateTime"; DateTime) { Caption = 'Closed DateTime'; }
        field(16; Billable; Boolean) { Caption = 'Billable'; }
        field(17; "Billable Amount"; Decimal) { Caption = 'Billable Amount'; DecimalPlaces = 2 : 5; }
        field(18; Description; Text[250]) { Caption = 'Description'; }
        field(19; "Resolution Notes"; Text[250]) { Caption = 'Resolution Notes'; }
        field(20; "Dimension Set ID"; Integer) { Editable = false; }
        field(21; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
        key(StatusIdx; Status) { }
    }

    trigger OnInsert()
    var
        NoSeriesHlp: Codeunit "SBX No. Series Helper";
    begin
        if Rec."No." = '' then
            Rec."No." := NoSeriesHlp.GetNextServiceRequestNo();
        if Rec."Open DateTime" = 0DT then
            Rec."Open DateTime" := CurrentDateTime;
    end;
}
