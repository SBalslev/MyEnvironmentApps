table 50134 "Rental KPI Buffer"
{
    DataClassification = SystemMetadata;
    fields
    {
        field(1; Code; Code[30]) { DataClassification = SystemMetadata; }
        field(2; Value; Decimal) { DataClassification = SystemMetadata; }
        field(3; "As Of"; DateTime) { DataClassification = SystemMetadata; }
        field(4; Description; Text[100]) { DataClassification = SystemMetadata; }
    }
    keys { key(PK; Code) { Clustered = true; } }
}
