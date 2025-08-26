codeunit 50302 "SBX Charge Engine"
{
    procedure GenerateChargesForDate(BillingDate: Date)
    var
        // Records (AA0021 ordering)
        ChargeLine: Record "SBX Recurring Charge Line";
        ChargeTemplate: Record "SBX Lease Charge Template";
        Lease: Record "SBX Lease";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Setup: Record "SBX Extensionarium Setup";
        // Codeunits
        DimHelper: Codeunit "SBX Dimension Helper";
        ProrationHlp: Codeunit "SBX Proration Helper";
        // Enums
        DimBehavior: Enum "SBX Dimension Behavior";
        ProrationMethod: Enum "SBX Proration Method";
        // Primitives / others
        LeaseNo: Code[20];
        CurrentInvoiceCreated: Boolean;
        ProratedAmount: Decimal;
        LineAmount: Decimal;
        PeriodStart: Date;
        PeriodEnd: Date;
        BillStart: Date;
        BillEnd: Date;
        DateIntervalDaysTok: Label '<%1D>', Comment = '%1 = number of days in generic day interval pattern';
    begin
        // Initialize variables (AA0205 unassigned variable warnings)
        LeaseNo := '';
        ChargeLine.SetCurrentKey("Lease No.", "Next Run Date");
        ChargeLine.SetRange("Next Run Date", 0D, BillingDate);
        ChargeLine.SetRange(Blocked, false);
        if ChargeLine.FindSet(true) then
            repeat
                if LeaseNo <> ChargeLine."Lease No." then begin
                    // Post previously built invoice if any
                    // Do not auto-post previous invoice; leave open for review/tests
                    CurrentInvoiceCreated := false;
                    LeaseNo := ChargeLine."Lease No.";
                    if Lease.Get(LeaseNo) then begin
                        // Create new invoice header
                        SalesHeader.Init();
                        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice);
                        SalesHeader.Validate("Sell-to Customer No.", Lease."Customer No.");
                        SalesHeader.Validate("Posting Date", BillingDate);
                        SalesHeader.Insert(true);
                        CurrentInvoiceCreated := true;
                    end;
                end;

                if CurrentInvoiceCreated and Lease.Get(ChargeLine."Lease No.") then begin
                    // Determine dimension behavior from template
                    if ChargeTemplate.Get(ChargeLine."Charge Code") then
                        DimBehavior := ChargeTemplate."Dimension Behavior"
                    else
                        Clear(DimBehavior);
                    DimHelper.ApplyDimensionsFromLease(ChargeLine."Dimension Set ID", ChargeLine."Lease No.", DimBehavior);

                    // Base line amount
                    LineAmount := ChargeLine.Amount;

                    // Derive period start/end (if first run Last Posted Date is 0 use frequency to back into start)
                    if ChargeLine."Last Posted Date" = 0D then begin
                        // For first period, approximate full period start based on frequency type
                        if ChargeLine."Frequency Type" = ChargeLine."Frequency Type"::Month then
                            PeriodStart := CalcDate('<-1M+1D>', ChargeLine."Next Run Date") // first day of prior period
                        else
                            PeriodStart := ChargeLine."Next Run Date" - 29; // 30-day default length
                    end else
                        PeriodStart := ChargeLine."Last Posted Date" + 1;
                    PeriodEnd := ChargeLine."Next Run Date";

                    BillStart := PeriodStart;
                    BillEnd := PeriodEnd;

                    if (ChargeLine."Prorate First" and (Lease."Last Invoiced Through Date" = 0D) and (Lease."Start Date" > PeriodStart)) then
                        BillStart := Lease."Start Date";
                    if (ChargeLine."Prorate Last" and (Lease."End Date" <> 0D) and (Lease."End Date" < PeriodEnd)) then
                        BillEnd := Lease."End Date";

                    if ((BillStart <> PeriodStart) or (BillEnd <> PeriodEnd)) then begin
                        if Setup.Get() then;
                        ProrationMethod := Setup."Default Proration Method";
                        ProratedAmount := ProrationHlp.ProrateAmount(LineAmount, PeriodStart, PeriodEnd, BillStart, BillEnd, ProrationMethod);
                        if ProratedAmount <> 0 then
                            LineAmount := ProratedAmount;
                    end;

                    // Create sales line
                    SalesLine.Init();
                    SalesLine.Validate("Document Type", SalesHeader."Document Type");
                    SalesLine.Validate("Document No.", SalesHeader."No.");
                    SalesLine.Validate(Type, SalesLine.Type::"G/L Account"); // Placeholder: map charge types later
                    SalesLine.Validate("No.", GetDefaultGLAccountForCharge(ChargeLine."Charge Type"));
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", LineAmount);
                    SalesLine.Insert(true);

                    // Update scheduling
                    ChargeLine."Last Posted Date" := ChargeLine."Next Run Date"; // period end just billed
                    if ChargeLine."Frequency Type" = ChargeLine."Frequency Type"::Month then
                        ChargeLine."Next Run Date" := CalcDate('<1M>', ChargeLine."Next Run Date")
                    else
                        ChargeLine."Next Run Date" := CalcDate(StrSubstNo(DateIntervalDaysTok, 30), ChargeLine."Next Run Date");
                    ChargeLine.Modify(true);

                    // Update lease invoiced through date to latest period end
                    if Lease."Last Invoiced Through Date" < ChargeLine."Last Posted Date" then begin
                        Lease."Last Invoiced Through Date" := ChargeLine."Last Posted Date";
                        Lease.Modify(true);
                    end;
                end;
            until ChargeLine.Next() = 0;

        // Leave last invoice unposted intentionally
    end;

    local procedure GetDefaultGLAccountForCharge(ChargeType: Enum "SBX Charge Type"): Code[20]
    var
        SetupRec: Record "SBX Extensionarium Setup";
    begin
        if SetupRec.Get() then
            case ChargeType of
                ChargeType::BaseRent:
                    if SetupRec."Rent G/L Account" <> '' then
                        exit(SetupRec."Rent G/L Account");
                else
                    if SetupRec."Charge G/L Account" <> '' then
                        exit(SetupRec."Charge G/L Account");
            end;
        exit('');
    end;
}
