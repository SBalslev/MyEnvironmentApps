codeunit 60030 "SBX Proration Tests"
{
    Subtype = Test;

    var
        Proration: Codeunit "SBX Proration Helper";
        TestLib: Codeunit "SBX Test Library";
        Lease: Record "SBX Lease";
        ChargeLine: Record "SBX Recurring Charge Line";
        Template: Record "SBX Lease Charge Template";
        Engine: Codeunit "SBX Charge Engine";
        Setup: Record "SBX Extensionarium Setup";
        Assert: Codeunit "Library Assert";

    [Test]
    procedure ExactDaily_ProrationHalfMonth()
    var
        Amount: Decimal;
        Result: Decimal;
        PeriodStart: Date;
        PeriodEnd: Date;
        BillStart: Date;
        BillEnd: Date;
    begin
        Amount := 1000;
        PeriodStart := DMY2Date(1, 1, 2025);
        PeriodEnd := DMY2Date(31, 1, 2025);
        BillStart := DMY2Date(16, 1, 2025);
        BillEnd := PeriodEnd;
        Result := Proration.ProrateAmount(Amount, PeriodStart, PeriodEnd, BillStart, BillEnd, "SBX Proration Method"::ExactDaily);
        Assert.IsTrue(Result > 450, 'Expected prorated > 450');
        Assert.IsTrue(Result < 550, 'Expected prorated < 550');
    end;

    [Test]
    procedure Commercial30_ProrationHalfMonth()
    var
        Amount: Decimal;
        Result: Decimal;
        PeriodStart: Date;
        PeriodEnd: Date;
        BillStart: Date;
        BillEnd: Date;
    begin
        Amount := 900;
        PeriodStart := DMY2Date(1, 4, 2025);
        PeriodEnd := DMY2Date(30, 4, 2025);
        BillStart := DMY2Date(16, 4, 2025);
        BillEnd := PeriodEnd;
        Result := Proration.ProrateAmount(Amount, PeriodStart, PeriodEnd, BillStart, BillEnd, "SBX Proration Method"::Commercial30);
        // Half of 900 = 450 using 30-day convention
        Assert.AreEqual(450, Round(Result, 0.01), 'Unexpected proration result');
    end;

    [Test]
    procedure Engine_ProrationAdjustsFirstPeriodAndUpdatesLease()
    var
        SalesH: Record "Sales Header";
        SalesL: Record "Sales Line";
        BilledAmt: Decimal;
    begin
        // Setup master data
        TestLib.EnsureCustomer('P-CUST', 'Prorate Customer');
        TestLib.EnsureProperty('P-PROP', 'Prorate Property');
        TestLib.EnsureUnit('P-PROP', 'P-UNIT');
        if not Setup.Get() then begin
            Setup.Init();
            Setup.Insert();
        end;
        Setup."Default Proration Method" := "SBX Proration Method"::ExactDaily;
        Setup.Modify(true);

        // Template
        Template.Init();
        Template.Code := 'PRORATE';
        Template.Description := 'Prorated Rent';
        Template."Charge Type" := Template."Charge Type"::BaseRent;
        Template."Frequency Interval" := 1;
        Template."Frequency Type" := Template."Frequency Type"::Month;
        Template.Amount := 3000; // Assume month 30 days => daily 100 for simple check
        Template."Dimension Behavior" := Template."Dimension Behavior"::PropertyOnly;
        Template.Insert();

        // Lease starting mid-month
        TestLib.CreateLease(Lease, 'P-CUST', 'P-PROP', 'P-UNIT', DMY2Date(16, 1, 2025), DMY2Date(31, 12, 2025), 3000);
        Lease.Status := Lease.Status::Active;
        Lease.Modify(true);

        // Charge line due end Jan (Next Run Date marks period end) with Prorate First
        ChargeLine.Init();
        ChargeLine."Lease No." := Lease."No.";
        ChargeLine."Charge Code" := Template.Code;
        ChargeLine."Charge Type" := ChargeLine."Charge Type"::BaseRent;
        ChargeLine.Amount := 3000;
        ChargeLine."Frequency Interval" := 1;
        ChargeLine."Frequency Type" := ChargeLine."Frequency Type"::Month;
        ChargeLine."Next Run Date" := DMY2Date(31, 1, 2025);
        ChargeLine."Prorate First" := true;
        ChargeLine.Insert(true);

        Engine.GenerateChargesForDate(DMY2Date(31, 1, 2025));

        ChargeLine.Get(ChargeLine."Entry No.");
        Assert.AreEqual(DMY2Date(31, 1, 2025), ChargeLine."Last Posted Date", 'Last Posted Date incorrect');
        // Expect half month billed (16-31 inclusive = 16 days of 31) ~ 1548.39 for ExactDaily. Accept range.
        // Find invoice line
        SalesH.SetRange("Document Type", SalesH."Document Type"::Invoice);
        SalesH.SetRange("Sell-to Customer No.", 'P-CUST');
        Assert.IsTrue(SalesH.FindFirst(), 'Invoice not created');
        SalesL.SetRange("Document Type", SalesH."Document Type");
        SalesL.SetRange("Document No.", SalesH."No.");
        Assert.IsTrue(SalesL.FindFirst(), 'Invoice line missing');
        BilledAmt := SalesL."Unit Price";
        Assert.IsTrue(BilledAmt > 1400, 'Prorated amount too low');
        Assert.IsTrue(BilledAmt < 1700, 'Prorated amount too high');
        Lease.Get(Lease."No.");
        Assert.AreEqual(DMY2Date(31, 1, 2025), Lease."Last Invoiced Through Date", 'Lease Last Invoiced Through Date not updated');
    end;
}
