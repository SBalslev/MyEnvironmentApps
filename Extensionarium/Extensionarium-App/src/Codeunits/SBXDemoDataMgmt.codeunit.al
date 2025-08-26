codeunit 50311 "SBX Demo Data Mgmt"
{
    SingleInstance = true;

    // Labels (AA0217 compliance for StrSubstNo format strings)
    var
        PropCodePatternTok: Label 'PROP-%1', Comment = '%1 = sequential property number padded to 3 digits';
        DemoPropertyNameTok: Label 'Demo Property %1', Comment = '%1 = sequential property number';
        LeaseCodePatternTok: Label 'LEASE-%1', Comment = '%1 = sequential lease number padded to 3 digits';
        MonthsBackFormulaTok: Label '<-%1M>', Comment = '%1 = months back from today for lease start date';
        UnitU1CreatedMsg: Label 'Unit %1-U1 created\\', Comment = '%1 = property code';
        UnitU2CreatedMsg: Label 'Unit %1-U2 created\\', Comment = '%1 = property code';
        PropertyCreatedMsg: Label 'Property %1 created\\', Comment = '%1 = property code';
        LeaseCreatedDraftMsg: Label 'Lease %1 created (Draft)\\', Comment = '%1 = lease code';
        LeaseActivatedMsg: Label 'Lease %1 activated\\', Comment = '%1 = lease code';
        RecurringLineCreatedMsg: Label 'Recurring Charge Line created (%1 BASE-RENT)\\', Comment = '%1 = lease code';
        DefaultGLPopulatedMsg: Label 'Default G/L accounts populated\\', Comment = 'Message shown when default G/L accounts are seeded';
        ChargeTemplateCreatedMsg: Label 'Charge Template %1 created\\', Comment = '%1 = charge template code';
        DepositEntryCreatedMsg: Label 'Deposit entry created (Collected 500)\\', Comment = 'Demo deposit ledger entry created';
        SampleInvoiceCreatedMsg: Label 'Sample sales invoice created (unposted)\\', Comment = 'Demo unposted sales invoice created';
        ServiceRequestCategoryCreatedMsg: Label 'Service Request Category %1 created\\', Comment = '%1 = category code';
        ServiceRequestCreatedMsg: Label 'Service Request %1 created\\', Comment = '%1 = service request number';

    procedure CreateDemoData()
    var
        Setup: Record "SBX Extensionarium Setup";
        Property: Record "SBX Property";
        Unit: Record "SBX Unit";
        Lease: Record "SBX Lease";
        ChargeTemplate: Record "SBX Lease Charge Template";
        ChargeTemplate2: Record "SBX Lease Charge Template";
        ChargeLine: Record "SBX Recurring Charge Line";
        ChargeLine2: Record "SBX Recurring Charge Line";
        SRCategory: Record "SBX Service Request Category";
        ServiceRequest: Record "SBX Service Request";
        GLAcc: Record "G/L Account";
        DepositEntry: Record "SBX Deposit Ledger Entry";
        Lease2: Record "SBX Lease";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Cust: Record Customer;
        LeaseMgt: Codeunit "SBX Lease Mgt.";
        CreatedTxt: Text;
        Today: Date;
        i: Integer;
        PropCode: Code[20];
        LeaseCode: Code[20];
        MonthsBack: Integer;
    begin
        Today := WorkDate();

        // Ensure setup exists
        if not Setup.Get('SETUP') then begin
            Setup.Init();
            Setup."Primary Key" := 'SETUP';
            Setup.Insert();
        end;

        // Populate default G/L accounts if blank (pick first posting income accounts found)
        if (Setup."Rent G/L Account" = '') or (Setup."Charge G/L Account" = '') then begin
            GLAcc.Reset();
            GLAcc.SetRange("Income/Balance", GLAcc."Income/Balance"::"Income Statement");
            if GLAcc.FindSet() then begin
                if Setup."Rent G/L Account" = '' then
                    Setup."Rent G/L Account" := GLAcc."No.";
                if (Setup."Charge G/L Account" = '') then begin
                    if GLAcc.Next() <> 0 then
                        Setup."Charge G/L Account" := GLAcc."No.";
                    if Setup."Charge G/L Account" = '' then
                        Setup."Charge G/L Account" := Setup."Rent G/L Account";
                end;
                Setup.Modify(true);
                CreatedTxt += DefaultGLPopulatedMsg;
            end;
        end;

        // Require at least one customer
        if Cust.IsEmpty() then
            Error('At least one customer must exist in the company before creating demo data.');

        // Base property
        if not Property.Get('PROP-DEMO') then begin
            Property.Init();
            Property.Code := 'PROP-DEMO';
            Property.Name := 'Demo Property';
            Property.Status := Property.Status::Active;
            Property.City := 'Demo City';
            Property.Insert(true);
            CreatedTxt += StrSubstNo(PropertyCreatedMsg, 'PROP-DEMO');
        end;

        // Units
        if not Unit.Get('PROP-DEMO', 'UNIT-1') then begin
            Unit.Init();
            Unit."Property Code" := 'PROP-DEMO';
            Unit."Unit Code" := 'UNIT-1';
            Unit.Status := Unit.Status::Vacant;
            Unit.Insert(true);
            CreatedTxt += 'Unit UNIT-1 created\\'; // literal single-use message (rule allows non-format)
        end;
        if not Unit.Get('PROP-DEMO', 'UNIT-2') then begin
            Unit.Init();
            Unit."Property Code" := 'PROP-DEMO';
            Unit."Unit Code" := 'UNIT-2';
            Unit.Status := Unit.Status::Vacant;
            Unit.Insert(true);
            CreatedTxt += 'Unit UNIT-2 created\\';
        end;

        // Charge templates
        if not ChargeTemplate.Get('BASE-RENT') then begin
            ChargeTemplate.Init();
            ChargeTemplate.Code := 'BASE-RENT';
            ChargeTemplate.Description := 'Base Monthly Rent';
            ChargeTemplate."Charge Type" := ChargeTemplate."Charge Type"::BaseRent;
            ChargeTemplate."Frequency Interval" := 1;
            ChargeTemplate."Frequency Type" := ChargeTemplate."Frequency Type"::Month;
            ChargeTemplate.Amount := 1000;
            ChargeTemplate.Active := true;
            ChargeTemplate."Dimension Behavior" := ChargeTemplate."Dimension Behavior"::PropertyAndUnit;
            ChargeTemplate.Insert(true);
            CreatedTxt += StrSubstNo(ChargeTemplateCreatedMsg, 'BASE-RENT');
        end;
        if not ChargeTemplate2.Get('SRV-CLEAN') then begin
            ChargeTemplate2.Init();
            ChargeTemplate2.Code := 'SRV-CLEAN';
            ChargeTemplate2.Description := 'Cleaning Service Fee';
            ChargeTemplate2."Charge Type" := ChargeTemplate2."Charge Type"::Service;
            ChargeTemplate2."Frequency Interval" := 1;
            ChargeTemplate2."Frequency Type" := ChargeTemplate2."Frequency Type"::Month;
            ChargeTemplate2.Amount := 150;
            ChargeTemplate2.Active := true;
            ChargeTemplate2."Dimension Behavior" := ChargeTemplate2."Dimension Behavior"::PropertyOnly;
            ChargeTemplate2.Insert(true);
            CreatedTxt += StrSubstNo(ChargeTemplateCreatedMsg, 'SRV-CLEAN');
        end;

        // Primary lease
        if not Lease.Get('LEASE-DEMO') then begin
            Lease.Init();
            Lease."No." := 'LEASE-DEMO';
            Lease."Customer No." := Cust."No.";
            Lease."Property Code" := 'PROP-DEMO';
            Lease."Unit Code" := 'UNIT-1';
            Lease."Start Date" := Today;
            Lease."Billing Start Date" := Today;
            Lease."Billing Frequency Interval" := 1;
            Lease."Frequency Type" := Lease."Frequency Type"::Month;
            Lease."Base Rent Amount" := 1000;
            Lease."Deposit Amount" := 500;
            Lease.Status := Lease.Status::Draft;
            Lease.Insert(true);
            CreatedTxt += StrSubstNo(LeaseCreatedDraftMsg, 'LEASE-DEMO');
            LeaseMgt.ActivateLease(Lease);
            Lease.Get('LEASE-DEMO');
            if Lease.Status = Lease.Status::Active then
                CreatedTxt += StrSubstNo(LeaseActivatedMsg, 'LEASE-DEMO');
        end;

        // Recurring charge lines (base + service)
        ChargeLine.Reset();
        ChargeLine.SetRange("Lease No.", 'LEASE-DEMO');
        ChargeLine.SetRange("Charge Code", 'BASE-RENT');
        if ChargeLine.IsEmpty() then begin
            Clear(ChargeLine);
            ChargeLine.Init();
            ChargeLine."Lease No." := 'LEASE-DEMO';
            ChargeLine."Charge Code" := 'BASE-RENT';
            ChargeLine."Charge Type" := ChargeLine."Charge Type"::BaseRent;
            ChargeLine.Amount := 1000;
            ChargeLine."Frequency Interval" := 1;
            ChargeLine."Frequency Type" := ChargeLine."Frequency Type"::Month;
            ChargeLine."Next Run Date" := CalcDate('<CM>', Today);
            ChargeLine."Prorate First" := true;
            if not ChargeLine.Insert(true) then;
            CreatedTxt += StrSubstNo(RecurringLineCreatedMsg, 'LEASE-DEMO');
        end;
        ChargeLine2.Reset();
        ChargeLine2.SetRange("Lease No.", 'LEASE-DEMO');
        ChargeLine2.SetRange("Charge Code", 'SRV-CLEAN');
        if ChargeLine2.IsEmpty() then begin
            Clear(ChargeLine2);
            ChargeLine2.Init();
            ChargeLine2."Lease No." := 'LEASE-DEMO';
            ChargeLine2."Charge Code" := 'SRV-CLEAN';
            ChargeLine2."Charge Type" := ChargeLine2."Charge Type"::Service;
            ChargeLine2.Amount := 150;
            ChargeLine2."Frequency Interval" := 1;
            ChargeLine2."Frequency Type" := ChargeLine2."Frequency Type"::Month;
            ChargeLine2."Next Run Date" := CalcDate('<CM>', Today);
            ChargeLine2."Prorate First" := true;
            if not ChargeLine2.Insert(true) then;
            CreatedTxt += StrSubstNo(RecurringLineCreatedMsg, 'LEASE-DEMO');
        end;

        // Secondary short lease
        if not Lease2.Get('LEASE-SHORT') then begin
            Lease2.Init();
            Lease2."No." := 'LEASE-SHORT';
            Lease2."Customer No." := Cust."No.";
            Lease2."Property Code" := 'PROP-DEMO';
            Lease2."Unit Code" := 'UNIT-2';
            Lease2."Start Date" := Today + 5;
            Lease2."Billing Start Date" := Today + 5;
            Lease2."Billing Frequency Interval" := 1;
            Lease2."Frequency Type" := Lease2."Frequency Type"::Month;
            Lease2."Base Rent Amount" := 800;
            Lease2.Status := Lease2.Status::Draft;
            Lease2.Insert(true);
            CreatedTxt += StrSubstNo(LeaseCreatedDraftMsg, 'LEASE-SHORT');
            LeaseMgt.ActivateLease(Lease2);
            Lease2.Get('LEASE-SHORT');
            if Lease2.Status = Lease2.Status::Active then
                CreatedTxt += StrSubstNo(LeaseActivatedMsg, 'LEASE-SHORT');
        end;

        // Deposit sample
        DepositEntry.Reset();
        DepositEntry.SetRange("Lease No.", 'LEASE-DEMO');
        if DepositEntry.IsEmpty() then begin
            DepositEntry.Init();
            DepositEntry."Lease No." := 'LEASE-DEMO';
            DepositEntry."Posting Date" := Today;
            DepositEntry.Amount := 500;
            DepositEntry.Type := DepositEntry.Type::Collected;
            DepositEntry."Document No." := 'DEP-DEMO';
            DepositEntry."User ID" := CopyStr(UserId(), 1, MaxStrLen(DepositEntry."User ID"));
            DepositEntry."Created DateTime" := CurrentDateTime;
            DepositEntry.Insert(true);
            CreatedTxt += DepositEntryCreatedMsg;
        end;

        // Sample invoice (unposted)
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader.SetRange("Sell-to Customer No.", Cust."No.");
        if SalesHeader.IsEmpty() then begin
            SalesHeader.Init();
            SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice);
            SalesHeader.Validate("Sell-to Customer No.", Cust."No.");
            SalesHeader.Validate("Posting Date", Today);
            SalesHeader.Insert(true);
            SalesLine.Init();
            SalesLine.Validate("Document Type", SalesHeader."Document Type");
            SalesLine.Validate("Document No.", SalesHeader."No.");
            SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
            SalesLine.Validate("No.", Setup."Rent G/L Account");
            SalesLine.Validate(Quantity, 1);
            SalesLine.Validate("Unit Price", 1000);
            SalesLine.Insert(true);
            CreatedTxt += SampleInvoiceCreatedMsg;
        end;

        // Service request category
        if not SRCategory.Get('MAINT') then begin
            SRCategory.Init();
            SRCategory.Code := 'MAINT';
            SRCategory.Description := 'General Maintenance';
            SRCategory."Default Priority" := SRCategory."Default Priority"::Normal;
            SRCategory."Default Billable" := false;
            SRCategory.Insert(true);
            CreatedTxt += StrSubstNo(ServiceRequestCategoryCreatedMsg, 'MAINT');
        end;

        // Service request
        if not ServiceRequest.Get('SR-DEMO') then begin
            ServiceRequest.Init();
            ServiceRequest."No." := 'SR-DEMO';
            ServiceRequest."Property Code" := 'PROP-DEMO';
            ServiceRequest."Unit Code" := 'UNIT-1';
            ServiceRequest."Lease No." := 'LEASE-DEMO';
            ServiceRequest."Customer No." := Cust."No.";
            ServiceRequest.Source := ServiceRequest.Source::Internal;
            ServiceRequest."Category Code" := 'MAINT';
            ServiceRequest.Priority := ServiceRequest.Priority::Normal;
            ServiceRequest.Status := ServiceRequest.Status::Open;
            ServiceRequest.Description := 'Leaking faucet reported in kitchen.';
            ServiceRequest.Insert(true);
            CreatedTxt += StrSubstNo(ServiceRequestCreatedMsg, 'SR-DEMO');
        end;

        if CreatedTxt = '' then
            Message('Demo data already exists.')
        else
            Message('Demo data created:\\%1', CreatedTxt);

        // Bulk extended data
        for i := 1 to 10 do begin
            PropCode := StrSubstNo(PropCodePatternTok, PadStr(Format(i), 3, '0'));
            if not Property.Get(PropCode) then begin
                Property.Init();
                Property.Code := PropCode;
                Property.Name := StrSubstNo(DemoPropertyNameTok, i);
                Property.Status := Property.Status::Active;
                Property.City := 'Demo City';
                Property.Insert(true);
                CreatedTxt += StrSubstNo(PropertyCreatedMsg, PropCode);
            end;

            if not Unit.Get(PropCode, 'U1') then begin
                Unit.Init();
                Unit."Property Code" := PropCode;
                Unit."Unit Code" := 'U1';
                Unit.Status := Unit.Status::Vacant;
                Unit.Insert(true);
                CreatedTxt += StrSubstNo(UnitU1CreatedMsg, PropCode);
            end;
            if not Unit.Get(PropCode, 'U2') then begin
                Unit.Init();
                Unit."Property Code" := PropCode;
                Unit."Unit Code" := 'U2';
                Unit.Status := Unit.Status::Vacant;
                Unit.Insert(true);
                CreatedTxt += StrSubstNo(UnitU2CreatedMsg, PropCode);
            end;

            LeaseCode := StrSubstNo(LeaseCodePatternTok, PadStr(Format(i), 3, '0'));
            if not Lease.Get(LeaseCode) then begin
                MonthsBack := i * 2;
                Lease.Init();
                Lease."No." := LeaseCode;
                Lease."Customer No." := Cust."No.";
                Lease."Property Code" := PropCode;
                Lease."Unit Code" := 'U1';
                Lease."Start Date" := CalcDate(StrSubstNo(MonthsBackFormulaTok, MonthsBack), Today);
                Lease."Billing Start Date" := Lease."Start Date";
                Lease."Billing Frequency Interval" := 1;
                Lease."Frequency Type" := Lease."Frequency Type"::Month;
                Lease."Base Rent Amount" := 800 + (i * 50);
                Lease."Deposit Amount" := 400 + (i * 25);
                Lease.Status := Lease.Status::Draft;
                Lease.Insert(true);
                CreatedTxt += StrSubstNo(LeaseCreatedDraftMsg, LeaseCode);
                LeaseMgt.ActivateLease(Lease);
                Lease.Get(LeaseCode);
                if Lease.Status = Lease.Status::Active then begin
                    Lease."Last Invoiced Through Date" := CalcDate('<-1M>', Today);
                    Lease.Modify(true);
                    CreatedTxt += StrSubstNo(LeaseActivatedMsg, LeaseCode);
                end;

                ChargeLine.Reset();
                ChargeLine.SetRange("Lease No.", LeaseCode);
                ChargeLine.SetRange("Charge Code", 'BASE-RENT');
                if ChargeLine.IsEmpty() then begin
                    Clear(ChargeLine);
                    ChargeLine.Init();
                    ChargeLine."Lease No." := LeaseCode;
                    ChargeLine."Charge Code" := 'BASE-RENT';
                    ChargeLine."Charge Type" := ChargeLine."Charge Type"::BaseRent;
                    ChargeLine.Amount := 800 + (i * 50);
                    ChargeLine."Frequency Interval" := 1;
                    ChargeLine."Frequency Type" := ChargeLine."Frequency Type"::Month;
                    ChargeLine."Next Run Date" := CalcDate('<CM>', Today);
                    ChargeLine."Prorate First" := true;
                    if not ChargeLine.Insert(true) then;
                    CreatedTxt += StrSubstNo(RecurringLineCreatedMsg, LeaseCode);
                end;
            end;
        end;

        if StrPos(CreatedTxt, 'PROP-010') > 0 then
            Message('Extended demo data (bulk) created/verified.\\(See earlier lines for initial objects.)');
    end;
}
