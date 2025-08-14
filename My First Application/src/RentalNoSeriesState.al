table 50108 "Rental No. Series State"
{
    DataClassification = SystemMetadata;
    fields
    {
        field(1; Code; Code[20]) { DataClassification = SystemMetadata; }
        field(2; "Last No."; Code[20]) { DataClassification = SystemMetadata; }
    }
    keys { key(PK; Code) { Clustered = true; } }
}
