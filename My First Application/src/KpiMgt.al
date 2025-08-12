codeunit 50135 "Rental KPI Mgt"
{
    procedure RefreshKPIs()
    var
        Lease: Record Lease;
        Units: Record Unit;
        SR: Record "Service Request";
        KPI: Record "Rental KPI Buffer";
        OccupancyPct: Decimal;
        ActiveUnits: Integer;
        TotalUnits: Integer;
        OpenSR: Integer;
        AvgResHours: Decimal;
        ClosedSR: Record "Service Request";
        Duration: Duration;
        TotalHours: Decimal;
        CountClosed: Integer;
    begin
        // Occupancy: count units not Inactive
        Units.Reset;
        Units.SetFilter(Status, '<>%1', Units.Status::Inactive);
        TotalUnits := 0;
        ActiveUnits := 0;
        if Units.FindSet() then
            repeat
                TotalUnits += 1;
            until Units.Next() = 0;
        Lease.SetRange(Status, Lease.Status::Active);
        if Lease.FindSet() then
            repeat
                ActiveUnits += 1; // simplistic: assumes one active lease per unit enforced elsewhere
            until Lease.Next() = 0;
        if TotalUnits > 0 then
            OccupancyPct := Round((ActiveUnits * 10000) / TotalUnits, 1) / 100;
        UpsertKPI('OCCUPANCY', OccupancyPct, 'Occupancy %');

        // Open service requests
        SR.SetFilter(Status, '%1|%2|%3|%4', SR.Status::New, SR.Status::Triaged, SR.Status::Assigned, SR.Status::"In Progress");
        OpenSR := SR.Count;
        UpsertKPI('OPEN_SR', OpenSR, 'Open Service Requests');

        // Avg resolution hours
        ClosedSR.SetFilter(Status, '%1|%2', ClosedSR.Status::Completed, ClosedSR.Status::Cancelled);
        if ClosedSR.FindSet() then begin
            repeat
                if (ClosedSR."Closed At" <> 0DT) and (ClosedSR."Opened At" <> 0DT) then begin
                    Duration := ClosedSR."Closed At" - ClosedSR."Opened At";
                    TotalHours += (Duration / 3600000);
                    CountClosed += 1;
                end;
            until ClosedSR.Next() = 0;
        end;
        if CountClosed > 0 then
            AvgResHours := Round(TotalHours / CountClosed, 0.01);
        UpsertKPI('AVG_RES_H', AvgResHours, 'Avg Resolution Hours');
    end;

    local procedure UpsertKPI(Code: Code[30]; Value: Decimal; Desc: Text[100])
    var
        KPI: Record "Rental KPI Buffer";
        Inserted: Boolean;
    begin
        if KPI.Get(Code) then begin
            KPI.Value := Value;
            KPI."As Of" := CurrentDateTime;
            KPI.Description := Desc;
            KPI.Modify(true);
        end else begin
            KPI.Init;
            KPI.Code := Code;
            KPI.Value := Value;
            KPI."As Of" := CurrentDateTime;
            KPI.Description := Desc;
            KPI.Insert(true);
        end;
    end;
}
