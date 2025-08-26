codeunit 50300 "SBX Lease Mgt."
{
    // Lease management core operations (activation, termination). More logic to be added.

    procedure ActivateLease(var Lease: Record "SBX Lease")
    var
        DimHelper: Codeunit "SBX Dimension Helper";
        DimBehavior: Enum "SBX Dimension Behavior";
    begin
        if Lease.Status <> Lease.Status::Draft then
            exit;
        if Lease."Start Date" = 0D then
            Error('Start Date must be set.');
        if (Lease."End Date" <> 0D) and (Lease."End Date" < Lease."Start Date") then
            Error('End Date must be after Start Date.');
        if Lease."Base Rent Amount" <= 0 then
            Error('Base Rent Amount must be greater than zero.');

        OnBeforeLeaseActivate(Lease);
        // Determine default dimension behavior for activation (Property and Unit)
        DimBehavior := DimBehavior::PropertyAndUnit;
        DimHelper.ApplyDimensionsFromLease(Lease."Dimension Set ID", Lease."No.", DimBehavior);
        Lease.Validate("Dimension Set ID", Lease."Dimension Set ID");
        Lease.Status := Lease.Status::Active;
        Lease.Modify(true);
        OnAfterLeaseActivate(Lease);
    end;

    procedure TerminateLease(var Lease: Record "SBX Lease")
    begin
        if Lease.Status <> Lease.Status::Active then
            exit;
        if Lease."End Date" = 0D then
            Error('Cannot terminate without End Date set.');
        OnBeforeLeaseTerminate(Lease);
        Lease.Status := Lease.Status::Terminated;
        Lease.Modify(true);
        OnAfterLeaseTerminate(Lease);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLeaseActivate(var Lease: Record "SBX Lease")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterLeaseActivate(Lease: Record "SBX Lease")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLeaseTerminate(var Lease: Record "SBX Lease")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterLeaseTerminate(Lease: Record "SBX Lease")
    begin
    end;
}
