report 50137 "Occupancy Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Occupancy by Property';
    dataset
    {
        dataitem(Property; Property)
        {
            column(Property_ID; "ID") { }
            column(Property_Name; Name) { }
            column(TotalUnits; TotalUnits) { }
            column(ActiveLeases; ActiveLeases) { }
            column(OccupancyPct; OccupancyPct) { }
            trigger OnAfterGetRecord()
            var
                UnitRec: Record Unit;
                LeaseRec: Record Lease;
                UnitCount: Integer;
                LeaseUnits: Dictionary of [Code[20], Boolean];
                ActiveCount: Integer;
            begin
                // Count non-inactive units
                UnitRec.SetRange("Property ID", "ID");
                UnitRec.SetFilter(Status, '<>%1', UnitRec.Status::Inactive);
                if UnitRec.FindSet() then begin
                    repeat
                        UnitCount += 1;
                    until UnitRec.Next() = 0;
                end;
                // Active leases
                // Fresh local dictionary each invocation; no need to clear explicitly.
                LeaseRec.SetRange(Status, LeaseRec.Status::Active);
                if LeaseRec.FindSet() then
                    repeat
                        // Need to join to unit to ensure same property
                        UnitRec.Reset;
                        UnitRec.SetRange("No.", LeaseRec."Unit No.");
                        UnitRec.SetRange("Property ID", "ID");
                        if UnitRec.FindFirst() then begin
                            if not LeaseUnits.ContainsKey(UnitRec."No.") then begin
                                LeaseUnits.Add(UnitRec."No.", true);
                                ActiveCount += 1;
                            end;
                        end;
                    until LeaseRec.Next() = 0;
                TotalUnits := UnitCount;
                ActiveLeases := ActiveCount;
                if TotalUnits > 0 then
                    OccupancyPct := Round((ActiveLeases * 10000) / TotalUnits, 1) / 100
                else
                    OccupancyPct := 0;
            end;

            trigger OnPreDataItem()
            begin
                if PropertyFilter <> '' then
                    SetFilter("ID", PropertyFilter);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(PropertyFilter; PropertyFilter) { ApplicationArea = All; Caption = 'Property Filter (Code Filter)'; ToolTip = 'Filter property codes (e.g. P*).'; }
                }
            }
        }
    }
    labels
    {
        OccupancyLbl = 'Occupancy %';
    }
    var
        PropertyFilter: Text[50];
        TotalUnits: Integer;
        ActiveLeases: Integer;
        OccupancyPct: Decimal;
}
