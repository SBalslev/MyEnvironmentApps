codeunit 60040 "SBX Dim & Term Tests"
{
    Subtype = Test;

    var
        // Records
        Lease: Record "SBX Lease";
        // Codeunits
        TestLib: Codeunit "SBX Test Library";
        LeaseMgt: Codeunit "SBX Lease Mgt.";
        Assert: Codeunit "Library Assert";

    [Test]
    procedure LeaseActivation_AppliesDimensions()
    begin
        TestLib.EnsureCustomer('10000', 'Test Customer');
        TestLib.EnsureProperty('PROP-DIM', 'Dim Property');
        TestLib.EnsureUnit('PROP-DIM', 'U1');
        TestLib.CreateLease(Lease, '10000', 'PROP-DIM', 'U1', DMY2Date(1, 1, 2025), DMY2Date(31, 12, 2025), 500);
        LeaseMgt.ActivateLease(Lease);
        Lease.Get(Lease."No.");
        Assert.IsTrue(Lease."Dimension Set ID" <> 0, 'Dimension Set ID not applied');
    end;

    [Test]
    procedure Termination_DoesNotAllowWithoutEndDate()
    var
        L2: Record "SBX Lease";
        HadError: Boolean;
    begin
        TestLib.EnsureCustomer('10000', 'Test Customer');
        TestLib.EnsureProperty('PROP-T', 'Term Property');
        TestLib.EnsureUnit('PROP-T', 'UT');
        TestLib.CreateLease(L2, '10000', 'PROP-T', 'UT', DMY2Date(1, 1, 2025), 0D, 200);
        L2.Status := L2.Status::Active;
        L2.Modify(true);
        ASSERTERROR LeaseMgt.TerminateLease(L2);
        HadError := true;
        Assert.IsTrue(HadError, 'Expected error on termination without End Date');
    end;
}
