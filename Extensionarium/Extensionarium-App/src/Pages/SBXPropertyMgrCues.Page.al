// Renamed from SBXPropertyMgrCuePart.page.al to satisfy AA0215
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
                    ToolTip = 'Number of active properties.';
                }
                field("Vacant Units"; Rec."Vacant Units")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "SBX Unit List";
                    ToolTip = 'Number of units currently vacant.';
                }
                field("Expiring Leases (30d)"; Rec."Expiring Leases (30d)")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "SBX Lease List";
                    ToolTip = 'Active leases ending within the next 30 days.';
                }
            }
            cuegroup(Leases)
            {
                field("Active Leases"; Rec."Active Leases")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "SBX Lease List";
                    ToolTip = 'Number of leases with status Active.';
                }
                field("Draft Leases"; Rec."Draft Leases")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "SBX Lease List";
                    ToolTip = 'Number of leases not yet activated.';
                }
                field("Distinct Active Customers"; Rec."Distinct Active Customers")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "SBX Lease List";
                    ToolTip = 'Number of distinct customers with at least one active lease.';
                }
            }
            cuegroup(ServiceRequests)
            {
                field("Open SR"; Rec."Open SR")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "SBX Service Request List";
                    ToolTip = 'Open service requests.';
                }
                field("In Progress SR"; Rec."In Progress SR")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "SBX Service Request List";
                    ToolTip = 'Service requests currently in progress.';
                }
                field("Unresolved SR"; Rec."Unresolved SR")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "SBX Service Request List";
                    ToolTip = 'Open or in-progress service requests not yet resolved.';
                }
                field("Open SR >7d"; Rec."Open SR >7d")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "SBX Service Request List";
                    ToolTip = 'Open or in-progress service requests older than 7 days.';
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
        CalcExpiringLeases();
        CalcAgingServiceRequests();
        CalcDistinctActiveCustomers();
        Rec.Modify();
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
        LastCustomer := '';
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
