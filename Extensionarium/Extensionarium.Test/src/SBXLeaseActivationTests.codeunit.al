codeunit 60010 "SBX Lease Activation Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Lease: Record "SBX Lease";
        LeaseMgt: Codeunit "SBX Lease Mgt.";
        TestLib: Codeunit "SBX Test Library";
        Assert: Codeunit "Library Assert";

    [Test]
    procedure ActivateLease_SetsStatusActive()
    begin
        // Setup
        TestLib.EnsureCustomer('10000', 'Test Customer');
        TestLib.EnsureProperty('PROP001', 'Test Property');
        TestLib.EnsureUnit('PROP001', 'UNIT001');
        TestLib.CreateLease(Lease, '10000', 'PROP001', 'UNIT001', DMY2Date(1, 1, 2025), DMY2Date(31, 12, 2025), 1000);
        Assert.AreEqual(Lease.Status::Draft, Lease.Status, 'Precondition failed: Lease should be Draft');
        // Exercise
        LeaseMgt.ActivateLease(Lease);
        // Verify
        Lease.Get(Lease."No.");
        Assert.AreEqual(Lease.Status::Active, Lease.Status, 'Lease was not activated');
    end;

    [Test]
    procedure ActivateLease_ValidationFailsOnMissingStartDate()
    var
        L2: Record "SBX Lease";
        HadError: Boolean;
    begin
        TestLib.EnsureCustomer('10000', 'Test Customer');
        TestLib.EnsureProperty('PROP001', 'Test Property');
        TestLib.EnsureUnit('PROP001', 'UNIT001');
        TestLib.CreateLease(L2, '10000', 'PROP001', 'UNIT001', 0D, DMY2Date(31, 12, 2025), 1000);
        ASSERTERROR LeaseMgt.ActivateLease(L2);
        HadError := true; // Only reached if an error occurred
        Assert.IsTrue(HadError, 'Expected error not raised');
    end;
}
