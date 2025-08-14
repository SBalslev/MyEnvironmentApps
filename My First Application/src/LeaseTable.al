table 50103 Lease
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20]) { DataClassification = CustomerContent; }
        field(2; "Unit No."; Code[20]) { DataClassification = CustomerContent; TableRelation = Unit."No."; }
        field(3; "Tenant No."; Code[20]) { DataClassification = CustomerContent; TableRelation = Tenant."No."; }
        field(4; "Start Date"; Date) { DataClassification = CustomerContent; }
        field(5; "End Date"; Date) { DataClassification = CustomerContent; }
        field(6; "Rent Amount"; Decimal) { DataClassification = CustomerContent; DecimalPlaces = 0 : 2; }
        field(7; "Deposit Amount"; Decimal) { DataClassification = CustomerContent; DecimalPlaces = 0 : 2; }
        field(8; Status; Enum "Lease Status") { DataClassification = CustomerContent; }
        field(9; "Termination Reason"; Text[100]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
        key(UnitIdx; "Unit No.") { }
        key(TenantIdx; "Tenant No.") { }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            RentalNoSeries.AssignLeaseNo(Rec);
        end;
        ValidateNoOverlap;
        AutoDeriveStatus;
    end;

    trigger OnModify()
    begin
        ValidateNoOverlap;
        AutoDeriveStatus;
    end;

    local procedure ValidateNoOverlap()
    var
        Existing: Record Lease;
        ThisStart: Date;
        ThisEnd: Date;
        ExistingStart: Date;
        ExistingEnd: Date;
    begin
        ThisStart := "Start Date";
        ThisEnd := "End Date";
        if ThisEnd = 0D then
            ThisEnd := DMY2Date(31, 12, 9999);

        Existing.SetRange("Unit No.", "Unit No.");
        Existing.SetFilter("No.", '<>%1', "No.");
        Existing.SetFilter(Status, '%1|%2|%3', Existing.Status::Active, Existing.Status::Future, Existing.Status::Draft);
        if Existing.FindSet() then
            repeat
                ExistingStart := Existing."Start Date";
                ExistingEnd := Existing."End Date";
                if ExistingEnd = 0D then
                    ExistingEnd := DMY2Date(31, 12, 9999);
                if (ThisStart <= ExistingEnd) and (ThisEnd >= ExistingStart) then
                    Error('Overlapping lease detected with lease %1 for unit %2.', Existing."No.", "Unit No.");
            until Existing.Next() = 0;
    end;

    local procedure AutoDeriveStatus()
    var
        TodayDate: Date;
    begin
        TodayDate := Today;
        if Status in [Status::Terminated, Status::Expired] then
            exit; // manual statuses retained

        if "Start Date" > TodayDate then
            Status := Status::Future
        else begin
            if ("End Date" <> 0D) and ("End Date" < TodayDate) then
                Status := Status::Expired
            else
                Status := Status::Active;
        end;
    end;

    var
        RentalNoSeries: Codeunit "Rental No. Series Mgt";
}
