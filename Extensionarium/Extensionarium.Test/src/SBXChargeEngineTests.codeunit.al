codeunit 60020 "SBX Charge Engine Tests"
{
    Subtype = Test;

    var
        Lease: Record "SBX Lease";
        ChargeLine: Record "SBX Recurring Charge Line";
        LeaseChargeTemplate: Record "SBX Lease Charge Template";
        ChargeEngine: Codeunit "SBX Charge Engine";
        TestLib: Codeunit "SBX Test Library";
        SalesInvHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Setup: Record "SBX Extensionarium Setup";
        Assert: Codeunit "Library Assert";

    [Test]
    procedure GenerateCharges_CreatesInvoiceAndAdvancesNextRun()
    begin
        // Setup master data
        TestLib.EnsureCustomer('10000', 'Test Customer');
        TestLib.EnsureProperty('PROP001', 'Test Property');
        TestLib.EnsureUnit('PROP001', 'UNIT001');
        TestLib.EnsureGLAccount('4000', 'Rent Income');
        TestLib.EnsureSetup(Setup."Default Proration Method"::ExactDaily);

        // Pre-create template
        LeaseChargeTemplate.Init();
        LeaseChargeTemplate.Code := 'BASE';
        LeaseChargeTemplate.Description := 'Base Rent';
        LeaseChargeTemplate."Charge Type" := LeaseChargeTemplate."Charge Type"::BaseRent;
        LeaseChargeTemplate."Frequency Interval" := 1;
        LeaseChargeTemplate."Frequency Type" := LeaseChargeTemplate."Frequency Type"::Month;
        LeaseChargeTemplate.Amount := 1000;
        LeaseChargeTemplate."Dimension Behavior" := LeaseChargeTemplate."Dimension Behavior"::PropertyOnly;
        LeaseChargeTemplate.Insert();

        // Create lease
        TestLib.CreateLease(Lease, '10000', 'PROP001', 'UNIT001', DMY2Date(1, 1, 2025), DMY2Date(31, 12, 2025), 1000);
        // Activate lease (simplified) - directly set status for test if needed
        Lease.Status := Lease.Status::Active;
        Lease.Modify(true);

        // Create charge line
        ChargeLine.Init();
        ChargeLine."Lease No." := Lease."No.";
        ChargeLine."Charge Code" := LeaseChargeTemplate.Code;
        ChargeLine."Charge Type" := ChargeLine."Charge Type"::BaseRent;
        ChargeLine.Amount := 1000;
        ChargeLine."Frequency Interval" := 1;
        ChargeLine."Frequency Type" := ChargeLine."Frequency Type"::Month;
        ChargeLine."Next Run Date" := DMY2Date(1, 2, 2025);
        ChargeLine.Insert(true);

        // Run engine for billing date Feb 1
        ChargeEngine.GenerateChargesForDate(DMY2Date(1, 2, 2025));

        // Assert invoice (unposted) exists for customer on date
        SalesInvHeader.SetRange("Document Type", SalesInvHeader."Document Type"::Invoice);
        SalesInvHeader.SetRange("Sell-to Customer No.", '10000');
        SalesInvHeader.SetRange("Posting Date", DMY2Date(1, 2, 2025));
        Assert.IsTrue(SalesInvHeader.FindFirst(), 'Expected invoice header not created');
        // Assert a line with amount
        SalesLine.SetRange("Document Type", SalesInvHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesInvHeader."No.");
        Assert.IsTrue(SalesLine.FindFirst(), 'Expected invoice line not found');
        Assert.AreEqual(1000, SalesLine."Unit Price", 'Unexpected line amount');

        ChargeLine.Get(ChargeLine."Entry No.");
        Assert.IsTrue(ChargeLine."Last Posted Date" <> 0D, 'Last Posted Date not updated');
        Assert.IsTrue(ChargeLine."Next Run Date" > DMY2Date(1, 2, 2025), 'Next Run Date not advanced');
    end;

    [Test]
    procedure GenerateCharges_UsesMappedGLAccounts()
    begin
        // Setup
        TestLib.EnsureCustomer('10001', 'GL Map Customer');
        TestLib.EnsureProperty('PROPGL', 'Property GL');
        TestLib.EnsureUnit('PROPGL', 'UNITGL');
        TestLib.EnsureGLAccount('4100', 'Rent Income GL');
        TestLib.EnsureGLAccount('4200', 'Other Charge GL');
        if not Setup.Get() then begin
            Setup.Init();
            Setup.Insert();
        end;
        Setup."Rent G/L Account" := '4100';
        Setup."Charge G/L Account" := '4200';
        Setup.Modify(true);

        // Template rent
        LeaseChargeTemplate.Init();
        LeaseChargeTemplate.Code := 'BASE2';
        LeaseChargeTemplate.Description := 'Base Rent 2';
        LeaseChargeTemplate."Charge Type" := LeaseChargeTemplate."Charge Type"::BaseRent;
        LeaseChargeTemplate."Frequency Interval" := 1;
        LeaseChargeTemplate."Frequency Type" := LeaseChargeTemplate."Frequency Type"::Month;
        LeaseChargeTemplate.Amount := 500;
        LeaseChargeTemplate."Dimension Behavior" := LeaseChargeTemplate."Dimension Behavior"::PropertyOnly;
        LeaseChargeTemplate.Insert();

        // Lease
        TestLib.CreateLease(Lease, '10001', 'PROPGL', 'UNITGL', DMY2Date(1, 1, 2025), DMY2Date(31, 12, 2025), 500);
        Lease.Status := Lease.Status::Active;
        Lease.Modify(true);

        // Charge line
        ChargeLine.Init();
        ChargeLine."Lease No." := Lease."No.";
        ChargeLine."Charge Code" := LeaseChargeTemplate.Code;
        ChargeLine."Charge Type" := ChargeLine."Charge Type"::BaseRent;
        ChargeLine.Amount := 500;
        ChargeLine."Frequency Interval" := 1;
        ChargeLine."Frequency Type" := ChargeLine."Frequency Type"::Month;
        ChargeLine."Next Run Date" := DMY2Date(1, 2, 2025);
        ChargeLine.Insert(true);

        ChargeEngine.GenerateChargesForDate(DMY2Date(1, 2, 2025));

        SalesInvHeader.SetRange("Document Type", SalesInvHeader."Document Type"::Invoice);
        SalesInvHeader.SetRange("Sell-to Customer No.", '10001');
        Assert.IsTrue(SalesInvHeader.FindFirst(), 'Invoice not created');
        SalesLine.SetRange("Document Type", SalesInvHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesInvHeader."No.");
        Assert.IsTrue(SalesLine.FindFirst(), 'Invoice line missing');
        Assert.AreEqual('4100', SalesLine."No.", 'Incorrect G/L account mapped for BaseRent');
    end;
}
