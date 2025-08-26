page 50151 "SBX Property Mgr Cues"
{
    PageType = CardPart;
    SourceTable = "SBX Property Mgr Cue";
    Caption = 'Property Management';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            cuegroup(Properties)
            {
                field("Active Properties"; Rec."Active Properties")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "SBX Property List";
                }
                field("Vacant Units"; Rec."Vacant Units")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "SBX Unit List";
                }
                field("Expiring Leases (30d)"; Rec."Expiring Leases (30d)")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "SBX Lease List";
                }
            }
            cuegroup(Leases)
            {
                field("Active Leases"; Rec."Active Leases")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "SBX Lease List";
                }
                field("Draft Leases"; Rec."Draft Leases")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "SBX Lease List";
                }
                field("Distinct Active Customers"; Rec."Distinct Active Customers")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "SBX Lease List";
                }
            }
            cuegroup(ServiceRequests)
            {
                field("Open SR"; Rec."Open SR")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "SBX Service Request List";
                }
                field("In Progress SR"; Rec."In Progress SR")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "SBX Service Request List";
                }
                field("Unresolved SR"; Rec."Unresolved SR")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "SBX Service Request List";
                }
                field("Open SR >7d"; Rec."Open SR >7d")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "SBX Service Request List";
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        EnsureRecord();
        RefreshData();
    end;

    local procedure EnsureRecord()
    begin
        if not Rec.Get('CUE') then begin
            Rec.Init();
            Rec."Primary Key" := 'CUE';
            Rec.Insert();
        end;
    end;

    local procedure RefreshData()
    begin
        Rec."Last Refreshed" := CurrentDateTime;
        // Compute dynamic KPIs
        CalcExpiringLeases();
        CalcAgingServiceRequests();
    CalcDistinctActiveCustomers();
        Rec.Modify();
        // FlowFields auto-calc on display; modification only stamps time
    end;

    local procedure CalcExpiringLeases()
    var
        Lease: Record "SBX Lease";
        ExpireDate: Date;
    begin
        ExpireDate := CalcDate('<+30D>', WorkDate());
        Lease.SetRange(Status, Lease.Status::Active);
        Lease.SetFilter("End Date", '..%1', ExpireDate);
        Rec."Expiring Leases (30d)" := Lease.Count();
    end;

    local procedure CalcAgingServiceRequests()
    var
        SR: Record "SBX Service Request";
        ThresholdDateTime: DateTime;
    begin
        ThresholdDateTime := CreateDateTime(WorkDate() - 7, 000000T);
        SR.SetFilter(Status, '%1|%2', SR.Status::Open, SR.Status::InProgress);
        SR.SetFilter("Open DateTime", '..%1', ThresholdDateTime);
        Rec."Open SR >7d" := SR.Count();
    end;

    local procedure CalcDistinctActiveCustomers()
    var
        Lease: Record "SBX Lease";
        LastCustomer: Code[20];
        CountDistinct: Integer;
    begin
        Lease.SetCurrentKey("Customer No.");
        Lease.SetRange(Status, Lease.Status::Active);
    if Lease.FindSet(false) then
            repeat
                if (Lease."Customer No." <> '') and (Lease."Customer No." <> LastCustomer) then begin
                    CountDistinct += 1;
                    LastCustomer := Lease."Customer No.";
                end;
            until Lease.Next() = 0;
        Rec."Distinct Active Customers" := CountDistinct;
    end;
}
